//
//  ComposableReadOnlyProperty.swift
//
//
//  Created by Óscar Morales Vivó on 4/17/23.
//

import Combine
import Foundation

/**
 Standard implementation of `ReadOnlyProperty`

 We will almost always use these in practice as opposed to the protocol existentials themselves. Having a protocol
 however allows for easy declaration of common functionality and polymorphism for the different model property
 struct types.
 */
public struct ComposableReadOnlyProperty<Value: Equatable>: ReadOnlyProperty {
    // MARK: - Initialization

    /**
     Initialization of a read-only model.

     Most of the time we'll want to use one of the factory methods, but if needed you can build a read-only model by
     hand. Alternatively you can just declare another type that adopts `ReadOnlyModelProtocol`
     - Note: Swift made us redeclare the default initializer here so it could be public 🤷🏽‍♂️
     */
    public init(updates: any Publisher<Value, Never>, getter: @escaping Getter) {
        self.updates = updates
        self.getter = getter
    }

    // MARK: - Types

    /**
     A block that implements a `ComposableProperty`'s getter.

     Note that the block is always expected to succeed without complaint.
     */
    public typealias Getter = () -> Value

    // MARK: - Stored Properties

    public var value: Value {
        getter()
    }

    public let updates: any Publisher<Value, Never>

    private let getter: Getter
}
