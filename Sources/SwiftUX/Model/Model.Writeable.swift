//
//  Model.Writeable.swift
//
//
//  Created by Óscar Morales Vivó on 3/26/23.
//

import Combine
import Foundation

/**
 Standard implementation of `WriteableProperty`

 We will almost always use these in practice as opposed to the protocol existentials themselves. Having a protocol
 however allows for easy declaration of common functionality and polymorphism for the different model property
 struct types.
 */
public struct ComposableWriteableProperty<Value: Equatable>: WriteableProperty {
    // MARK: - Initialization

    /**
     Initialization of a writeable composable property.

     Most of the time we'll want to use one of the factory methods, but if needed you can build a writeable model by
     hand.
     - Note: Swift made us redeclare the default initializer here so it could be public 🤷🏽‍♂️
     */
    public init(updates: any Publisher<Value, Never>, getter: @escaping Getter, setter: @escaping Setter) {
        self.updates = updates
        self.getter = getter
        self.setter = setter
    }

    // MARK: - Types

    /**
     A block that implements a `ComposableProperty`'s getter.

     Note that the block is always expected to succeed without complaint.
     */
    public typealias Getter = () -> Value

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

public extension Model {
    typealias Writeable = ComposableWriteableProperty<Value>
}
