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

 The model storage and update validation logic is abstract, hidden behind a composable value type, which allows for
 flexibility building things like hierarchical controllers where you can for example build a controller for a part of a
 larger model (see `KeyPathProperty` and `KeyValueProperty` for the most common child controller builders).

 An instance can be used to both feed SwiftUI views (therefore the compliance with `ObservableObject`) and UIKit ones
 through manual subscription to its model property `updates` publisher. Outside of SwiftUI it is not recommended to
 subscribe to `$model` since it triggers _before_ the model update itself which tends to make for glitchy update loops.

 `ID` is used to uniquely identify a controller so it can easily be reused if multiple components in an app want to
 display and/or edit the same data. `Identifiable` conformance comes from `ControllerProtocol`.

 `Model` can be any type that conforms to equatable but value types are recommended. Special care must be taken when
 using reference types as there's nothing in the Swift language that prevents their contents from being modified outside
 the controller's scope, and the controller machinery would have no way to detect those changes.

 `Persistence` is the type that will be used for persisting edits, fetching data and obtaining data updates. It is
 left undetermined as the needs of various controllers vary wildly, but should almost always be a protocol type as to
 allow for easy mocking in tests.

 In some cases (i.e. simple UI display of existing data) there is no need for a persistence type altogether. Use `Void`
 to intantiate the controller type in those cases.

 Most of the time app controllers will be explicit subclasses of `Controller`, made easier to declare by the
 `ReadOnlyController` and `WritableController` `typealias` declarations and often managed through use of a
 `ObjectManager`. Specific app functionality can then be declared on those subclasses. Where desired, common
 functionality for controllers managing the same type can be provided through extensions.
 */
@MainActor
open class Controller<ID: Hashable, Model: Equatable, ModelProperty: Property, Persistence>:
    ControllerProtocol where ModelProperty.Value == Model {
    /**
     Designated initializer.

     The designated initializer for a controller takes an id, a model property and a persistence value of the expected
     types.
     - parameter id: The id for the controller. It is immutable once set.
     - parameter modelProperty: Model property that this controller will manage. Cannot be swapped with a different one
     once set. Its contents can be edited for a controller where `ModelProperty == WritableController<Model>`
     - parameter persistence: The persistence that the controller will use to persist and fetch its data.
     */
    public init(id: ID, model: ModelProperty, persistence: Persistence) {
        self.id = id
        self.model = model
        self.persistence = persistence
    }

    public typealias ID = ID

    public typealias Model = Model

    public typealias Persistence = Persistence

    /**
     The controller's unique ID.
     */
    public let id: ID

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
    public let model: ModelProperty
}

// MARK: - Convenience for non-persisting controllers

public extension Controller where Persistence == Void {
    /**
     Convenience initializer for non-persisting controllers.

     For controllers that don't do persistence, this convenience initializer takes care of hiding things for a more
     straightforward experience.

     All other parameters are the same as in the designated initializer.
     - parameter id: The id for the controller. It is immutable once set.
     - parameter modelProperty: Model property that this controller will manage. Cannot be swapped with a different one
     once set. Its contents can be edited for a controller where `ModelProperty == WritableController<Model>`
     */
    convenience init(id: ID, modelProperty: ModelProperty) {
        self.init(id: id, model: modelProperty, persistence: ())
    }
}

// MARK: ReadOnlyController

/**
 When subclassing a read only controller, use this typealias to make the declaration both shorter and more readable.
 */
public typealias ReadOnlyController<ID: Hashable, Model: Equatable, Persistence> =
    Controller<ID, Model, ReadOnlyProperty<Model>, Persistence>

// MARK: WritableController

/**
 When subclassing a writable controller, use this typealias to make the declaration both shorter and more readable.
 */
public
typealias WritableController<ID: Hashable, Model: Equatable, Persistence> =
    Controller<ID, Model, WritableProperty<Model>, Persistence>

public extension Controller where ModelProperty == WritableProperty<Model> {
    /**
     The edit block type for a controller with a writable model.

     The block takes an initial value, applies any changes to it as desired, and returns the resulting value.
     */
    typealias Edit = (Model) -> Model

    /**
     Applies the given edit to the current model value and updates it with the result.

     The `model` property of the controller will be updated by its subscription to `modelProperty.updates` immediately
     after the value is changed.
     - Parameter edit: The edit operation to apply to the model's value. It gets as input the current value of the model
     and outputs the new value.
     - Todo: Undo/Redo support.
     - Todo: Persistence support.
     */
    func apply(edit: Edit) {
        model.value = edit(model.value)
    }
}
