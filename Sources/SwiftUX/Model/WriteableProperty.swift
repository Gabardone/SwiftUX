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
     */
    var value: Value { get set }
}
