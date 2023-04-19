//
//  ReadOnlyProperty.swift
//
//
//  Created by Óscar Morales Vivó on 4/17/23.
//

import Combine
import Foundation

/**
 Standard implementation of a read-only `Property`

 Since they are built with a publisher and a getter block, any specific functionality can be achieved with some smart
 functional programming. For the most part you should use the provided factory methods to build them up.
 */
public struct ReadOnlyProperty<Value: Equatable>: Property {
    // MARK: - Initialization

    /**
     Initialization of a read-only property.

     Most of the time we'll want to use one of the factory methods, but if needed you can build a read-only model by
     hand. See the provided ones for examples on how to build these.
     - Note: Swift made us redeclare the default initializer here so it could be public 🤷🏽‍♂️
     - Parameter updates: The publisher that vends updates to the property.
     - Parameter getter: A block that returns the current value of the property.
     */
    public init(updates: any Publisher<Value, Never>, getter: @escaping Getter) {
        self.updates = updates
        self.getter = getter
    }

    // MARK: - Types

    /**
     A block that implements a `ReadOnlyProperty`'s getter.

     Note that the block is always expected to succeed without complaint.
     */
    public typealias Getter = () -> Value

    // MARK: - Stored Properties

    public let updates: any Publisher<Value, Never>

    private let getter: Getter

    // MARK: - Computed Properties

    public var value: Value {
        getter()
    }
}
