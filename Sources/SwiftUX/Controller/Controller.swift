//
//  Controller.swift
//
//
//  Created by Óscar Morales Vivó on 03/28/23.
//

import Combine
import Foundation
import os

// Swift does not support static members on generic classes so we build a global controller logger object.
private let controllerLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Controller")

/**
 A generic controller class that manages a model.

 The model storage and update validation logic is abstract, hidden behind a protocol, which allows for flexibility
 building things like hierarchical controllers where you can for example build a controller for a part of a larger model
 (see `KeyPathModelProperty` and `KeyValueModelProperty` for the most common child controller builders).

 An instance can be used to both feed SwiftUI views (therefore the compliance with `ObservableObject`) and UIKit ones
 through manual subscription to its model publisher.

 `Model` can be any type that conforms to equatable but value types are recommended. Special care must be taken when
 using reference types as there's nothing in the Swift language that prevents their contents from being modified outside
 the controller's scope.

 `Persistence` is the type that will be used for persisting edits, fetching data and obtaining data updates. It's
 left undetermined as the needs of various controllers vary wildly, but should almost always be a protocol type as to
 allow for easy mocking in tests. Common functionality will be provided with adoptable protocols for those persistence
 types that bring controller utilities via `extension Controller where Persistence: SomeProtocol`

 In some cases (i.e. simple UI display of existing data) there's no need for a persistence type altogether. Use `Void`
 to intantiate the controller type in those cases.
 */
@MainActor
open class Controller<ID: Hashable, ModelProperty: ReadOnlyProperty, Persistence>: Identifiable, ObservableObject {
    /**
     Designated initializer.

     The designated initializer for a controller takes an id, a model property and a persistence value of the expected
     type.
     - parameter id: The id for the controller. It is immutable once set.
     - parameter modelProperty: Model property that this controller will manage. Immutable once set.
     - parameter persistence: The persistence that the controller will use to persist and fetch its data.
     */
    public required init(id: ID, modelProperty: ModelProperty, persistence: Persistence) {
        self.id = id
        self.model = modelProperty.value
        self.modelProperty = modelProperty
        self.persistence = persistence

        // Make sure updates on the abstract model property reflect on the stored property. If there's an error
        // upstream we just stop updating since `@Published` doesn't support errors.
        modelProperty.updates.assign(to: &$model)
    }

    public typealias ID = ID

    public typealias Model = ModelProperty.Value

    public typealias Persistence = Persistence

    /// The controller's unique ID for the type.
    public let id: ID

    /**
     The model value currently held by the controller.

     The setter is not publically accessible, it should only be updated from the outside indirectly through use of
     `apply(edit:)`. Per the behavior of its managed model property it should only update if the new value is different
     than the currently stored one, so there is no need to use `removeDuplicates` on the projected publisher.

     Vended as an `@Published` property wrapper so it can more easily be used to feed SwiftUI views.
     - Warning: `@Publisher` emits updates on `willSet`, so remember to use the given value but not check on the
     original property value when receiving updates to your subscription. That also means that often child controllers
     will receive updates before their parents have updated.
     */
    @Published
    public private(set) var model: Model

    /**
     The persistence used by the controller to persist edits and fetch data.

     While it should _not_ be used from the outside, access is often needed to build up persistence for child
     controllers. How that goes is dependent on the specific persistence implementation.
     */
    public let persistence: Persistence

    /**
     The model property that the controller is managing. If using the validated or persisted APIs it shouldn't be
     updated directly unless
     */
    public private(set) var modelProperty: ModelProperty
}

// MARK: - Convenience for non-persisting controllers

public extension Controller where Persistence == Void {
    /**
     Convenience initializer for non-persisting controllers.

     For controllers that don't do persistence, this convenience initializer takes care of hiding things for a more
     straightforward experience.

     All other parameters are the same as in the designated initializer.
     */
    convenience init(id: ID, modelProperty: ModelProperty) {
        self.init(id: id, modelProperty: modelProperty, persistence: ())
    }
}

// MARK: Editability

public extension Controller where ModelProperty: WriteableProperty {
    /**
     The edit block type for a controller with safe editing.

     The block takes an initial value, applies any changes to it as desired, and returns the resulting value.
     */
    typealias Edit = (Model) -> Model

    /**
     Applies the given edit to the current model value and updates it with the result.
     - Parameter edit: The edit operation to apply to the model's value. It gets as input the current value of the model
     and outputs the new value.
     - Todo: Undo/Redo support.
     - Todo: Persistence support.
     */
    func apply(edit: Edit) {
        modelProperty.value = edit(modelProperty.value)
    }
}
