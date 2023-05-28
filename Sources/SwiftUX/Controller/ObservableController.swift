//
//  ObservableController.swift
//
//
//  Created by Óscar Morales Vivó on 5/27/23.
//

import Combine
import Foundation

/**
 A wrapper for a `Controller` that allows it to be used from SwiftUI as an `@ObservableObject` data source.

 While the wrapper allows for access to the controller, it is recommended to leave untouched in SwiftUI code except for
 calls to `apply` (if editable) or to pass it around to other UI components.

 Otherwise the difference in behavior between `controller.model` and `ObservableWrapper.model` may lead to unexpected
 behaviors, since the former updates its subscribers after updating its stored value, while `@Published` does the
 opposite.

 You generally shouldn't try to instantiate this class directly, intead having your `Controller` subclasses adopt the
 `ObservableWrappable` protocol and using the `observable()` function within to bridge UIKit and SwiftUI components.
 Between SwiftUI components just pass the wrapper around if they both use the same observable controller type.
 */
@MainActor
public final class ObservableController<C>: ObservableObject where C: ControllerProtocol {
    init(_ wrapping: C) {
        self.source = wrapping
        self.model = source.model.value
        self.subscription = source.model.updates.sink { [weak self] newValue in
            self?.model = newValue
        }
    }

    /**
     Type of controller wrapped.
     */
    public typealias Controller = C

    /**
     Access to the source controller. Use it to pass around, derive new controllers and call `apply` methods on editable
     ones.
     */
    public let source: Controller

    /**
     The `@Published` model vended to SwiftUI logic. your SwiftUI logic should always refer to this instead of
     `source.model.value` to inform its view building.
     */
    @Published
    public private(set) var model: C.ModelProperty.Value

    private var subscription: AnyCancellable?
}

/**
 Marker protocol for controller types that need to be bridged to SwiftUI.

 Since subclasses of `Controller` should always be `final`, adding a compliance with this protocol should never cause
 issues. Unfortunately it needs to be done for every subclass that needs it.
 */
@MainActor
public protocol ObservableWrappable {}

public extension ObservableWrappable where Self: ControllerProtocol {
    typealias Observable = ObservableController<Self>

    /**
     Call this method from your controller to get an `ObservableController` wrapper you can use to feed a SwiftUI
     `ObservedObject` property. This makes it easy to configure the SwiftUI view based on its managed
     `@Published var model` property.
     */
    func observable() -> ObservableController<Self> {
        ObservableController(self)
    }
}
