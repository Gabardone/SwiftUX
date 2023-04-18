//
//  AnyWriteableProperty.swift
//
//
//  Created by Óscar Morales Vivó on 4/17/23.
//

import Foundation

/**
 Type eraser for an existential value of `WriteableProperty`
 */
public struct AnyWriteableProperty<Value: Equatable> {
    /// Swift made us define this initializer.
    public init(wrapped: any WriteableProperty<Value>) {
        self.wrapped = wrapped
    }

    public var wrapped: any WriteableProperty<Value>
}

extension AnyWriteableProperty: WriteableProperty {
    public typealias Value = Value

    public var value: Value {
        @inlinable
        get {
            wrapped.value
        }

        @inlinable
        nonmutating set {
            wrapped.value = newValue
        }
    }

    @inlinable
    public var updates: UpdatePublisher {
        wrapped.updates
    }
}
