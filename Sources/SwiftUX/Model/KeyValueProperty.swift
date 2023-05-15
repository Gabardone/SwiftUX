//
//  KeyValueProperty.swift
//
//
//  Created by Óscar Morales Vivó on 5/13/23.
//

import Foundation

public protocol KeyValueCollection {
    associatedtype Key: Hashable

    associatedtype Value

    subscript(_: Key) -> Value? { get set }
}

public extension WritableProperty where Value: KeyValueCollection, Value.Value: Equatable {
    /**
     Returns a `WritableProperty` that vends the value at the caller's `keyPath`

     This utility allows to easily build a hierarchy of model properties, with the one returned from this method both
     fetching its value and writing it on top of its parent (the caller).
     - Parameter keyPath: The key path pointing to the property of the caller we want the new model property to manage.
     - Returns: A read/write model property that manages the value at the caller's `keyPath`.
     */
    func writableKeyValue(_ key: Value.Key, initialValue: Value.Value) -> WritableProperty<Value.Value> {
        // Required for compilation. Remember that copies are expected to point to the same value/update publisher.
        // The update publisher requires being prepended with the current value and then dropping it as to prime
        // `removeDuplicates` so changes in the parent outside our purview to trigger updates.
        var lastValue = initialValue
        return .init(
            updates: updates
                .eraseToAnyPublisher()
                .compactMap { newValue in
                    guard let result = newValue[key] else {
                        return nil
                    }

                    lastValue = result
                    return result
                }
                .prepend(initialValue)
                .removeDuplicates()
                .dropFirst()
        ) {
            lastValue
        } setter: { newValue in
            guard newValue != value[key] else { return }
            value[key] = newValue
        }
    }
}

public extension Property where Value: KeyValueCollection, Value.Value: Equatable {
    /**
     TBD
     */
    func readOnlyKeyValue(_ key: Value.Key, initialValue: Value.Value) -> ReadOnlyProperty<Value.Value> {
        // The update publisher requires being prepended with the current value and then dropping it as to prime
        // `removeDuplicates` so changes in the parent outside our purview to trigger updates.
        var lastValue = initialValue
        return .init(
            updates: updates
                .eraseToAnyPublisher()
                .compactMap { newValue in
                    guard let result = newValue[key] else {
                        return nil
                    }

                    lastValue = result
                    return result
                }
                .prepend(initialValue)
                .removeDuplicates()
                .dropFirst()
        ) {
            lastValue
        }
    }
}
