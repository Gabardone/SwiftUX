//
//  AnyReadOnlyProperty.swift
//
//
//  Created by Óscar Morales Vivó on 4/17/23.
//

import Combine
import Foundation

/**
 Type eraser for an existential value of `ReadOnlyProperty`
 */
public struct AnyReadOnlyProperty<Value: Equatable> {
    /// Swift made us define this initializer.
    public init(wrapped: any ReadOnlyProperty<Value>) {
        self.wrapped = wrapped
    }

    public var wrapped: any ReadOnlyProperty<Value>
}

extension AnyReadOnlyProperty: ReadOnlyProperty {
    public typealias Value = Value

    @inlinable
    public var value: Value {
        wrapped.value
    }

    @inlinable
    public var updates: UpdatePublisher {
        wrapped.updates
    }
}
