//
//  MutableProperty.swift
//
//
//  Created by Óscar Morales Vivó on 5/17/23.
//

import Foundation

/**
 A specialization of the `Property` protocol where `value` can be modified directly.
 */
public protocol MutableProperty: Property {
    var value: Value { get nonmutating set }
}
