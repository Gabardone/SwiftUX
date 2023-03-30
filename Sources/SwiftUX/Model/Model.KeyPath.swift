//
//  Model.KeyPath.swift
//
//
//  Created by Óscar Morales Vivó on 3/26/23.
//

import Foundation

public extension WriteableProperty {
    /**
     Returns a read/write model property that vends the value at the caller's `keyPath`

     This utility allows to easily build a hierarchy of model properties, with the one returned from this method both
     fetching its value and writing it on top of its parent (the caller).
     - Parameter keyPath: The key path pointing to the property of the caller we want the new model property to manage.
     - Returns: A read/write model property that manages the value at the caller's `keyPath`.
     */
    func writableKeyPath<Derived: Equatable>(_ keyPath: WritableKeyPath<Value, Derived>) -> Model<Derived>.Writeable {
        // Required for compilation. Remember that copies are expected to point to the same value/update publisher.
        var proxy = self
        // The update publisher requires being prepended with the current value and then dropping it as to prime
        // `removeDuplicates` so changes in the parent outside our purview to trigger updates.
        return .init(
            updates: updates.eraseToAnyPublisher().map(keyPath).prepend(value[keyPath: keyPath]).removeDuplicates().dropFirst()
        ) {
            proxy.value[keyPath: keyPath]
        } setter: { newValue in
            guard newValue != proxy.value[keyPath: keyPath] else { return }
            proxy.value[keyPath: keyPath] = newValue
        }
    }
}

public extension ReadOnlyProperty {
    /**
     Returns a read-only model property that vends the value at the caller's `keyPath`

     This utility allows to easily build a hierarchy of model properties, with the one returned from this method
     fetching its value from its parents and filtering any parental updates to only those that change the value at
     `keyPath`.
     - Parameter keyPath: The key path pointing to the property of the caller we want the new model property to manage.
     - Returns: A read-only model property that manages the value at the caller's `keyPath`.
     */
    func readOnlyKeyPath<Derived: Equatable>(_ keyPath: KeyPath<Value, Derived>) -> Model<Derived>.ReadOnly {
        // The update publisher requires being prepended with the current value and then dropping it as to prime
        // `removeDuplicates` so changes in the parent outside our purview to trigger updates.
        .init(
            updates: updates.eraseToAnyPublisher().map(keyPath).prepend(value[keyPath: keyPath]).removeDuplicates().dropFirst()
        ) {
            value[keyPath: keyPath]
        }
    }
}
