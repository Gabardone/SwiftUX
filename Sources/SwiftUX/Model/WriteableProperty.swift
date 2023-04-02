//
//  WriteableProperty.swift
//
//
//  Created by Óscar Morales Vivó on 3/25/23.
//

import Foundation

/**
 A `Model` whose value can also directly be written.

 Unlike `EditableProperty` there is no attempt at managing edit transactions, validation of inputs or any expectation
 that a mutation operation may fail.

 Useful mostly for root properties of model hierarchies and other instances where the model can be easily managed at
 the point of use and there are no sync validation or transaction concerns.
 */
public protocol WriteableProperty<Value>: ReadOnlyProperty where Value: Equatable {
    /**
     The value of a `WriteableModelProtocol` implementation can, as expected, be set.
     - Note: The setter is marked as `nonmutating` to enforce the reference semantics of the held value and to avoid
     tripping the Swift mutability reentry checker since setters tend to have a lot of side effects due to them
     triggering `updates` publishers at the tail end of their work.
     */
    var value: Value { get nonmutating set }
}
