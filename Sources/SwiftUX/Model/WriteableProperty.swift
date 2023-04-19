//
//  WriteableProperty.swift
//
//
//  Created by Óscar Morales Vivó on 3/25/23.
//

import Combine
import Foundation

/**
 Standard writeable property.

 Since they are built with a publisher, getter and setter blocks, any specific functionality can be achieved with some
 smart functional programming. For the most part you should use the provided factory methods to build them up.
 */
public struct WriteableProperty<Value: Equatable>: Property {
    // MARK: - Initialization

    /**
     Initialization of a writeable composable property.

     Most of the time we'll want to use one of the factory methods, but if needed you can build a read-only model by
     hand. See the provided ones for examples on how to build these.
     - Note: Swift made us redeclare the default initializer here so it could be public 🤷🏽‍♂️
     - Parameter updates: The publisher that vends updates to the property.
     - Parameter getter: A block that returns the current value of the property.
     - Parameter setter: A block that sets the current value of the property. Should cause `updates` to call its
     subscribers if it's different from the current value.
     */
    public init(updates: any Publisher<Value, Never>, getter: @escaping Getter, setter: @escaping Setter) {
        self.updates = updates
        self.getter = getter
        self.setter = setter
    }

    // MARK: - Types

    /**
     A block that implements a `WriteableProperty` value getter.

     Note that the block is always expected to succeed without complaint.
     */
    public typealias Getter = () -> Value

    /**
     A block that implements a `WriteableProperty` value setter.

     Note that the block is always expected to succeed without complaint.
     */
    public typealias Setter = (Value) -> Void

    // MARK: - Stored Properties

    public let updates: any Publisher<Value, Never> // Swift didn't let us declare this as `UpdatePublisher` 🤷🏽‍♂️

    private let getter: Getter

    private let setter: Setter

    // MARK: - Computed Properties

    public var value: Value {
        get {
            getter()
        }

        nonmutating set {
            setter(newValue)
        }
    }
}
