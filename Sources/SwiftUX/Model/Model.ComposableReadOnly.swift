//
//  Model.ComposableReadOnly.swift
//  
//
//  Created by Óscar Morales Vivó on 3/25/23.
//

import Combine
import Foundation

/**
 The baseline implementation of `ReadOnlyModelProtocol`

 The behavior of one of these obviously depends on the parameters passed to it, so it's up to the developer to verify
 that it fulfills the semantic requirements of the `ReadOnlyModel` protocol.

 Beyond that they can easily be used either as a way to build derived properties from other data or for testing
 purposes. Most of the package ones and most of the ones used in real code are going to be of this type, although
 nothing stops folks from building custom ones whenever convenient to do so.
 */
//public struct ReadOnlyModel<Value: Equatable>: ReadOnlyModelProtocol {
//
//    // MARK: - Initialization
//
//    /**
//     Initialization of a read-only model.
//
//     Most of the time we'll want to use one of the factory methods, but if needed you can build a read-only model by
//     hand. Alternatively you can just declare another type that adopts `ReadOnlyModelProtocol`
//     - Note: Swift made us redeclare the default initializer here so it could be public 🤷🏽‍♂️
//     */
//    public init(updates: any Publisher<Value, Never>, getter: @escaping Getter) {
//        self.updates = updates
//        self.getter = getter
//    }
//
//    // MARK: - Types
//
//    /**
//     A block that implements a `ComposableProperty`'s getter.
//
//     Note that the block is always expected to succeed without complaint.
//     */
//    public typealias Getter = () -> Value
//
//    // MARK: - Stored Properties
//
//    public var value: Value {
//        getter()
//    }
//
//    public let updates: any Publisher<Value, Never>
//
//    private let getter: Getter
//}
//
//// MARK: - Property Adoption
//
////extension ReadOnlyModel:  {
////}
