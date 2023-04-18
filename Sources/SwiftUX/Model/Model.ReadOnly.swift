//
//  Model.ReadOnly.swift
//
//
//  Created by Óscar Morales Vivó on 3/25/23.
//

import Foundation

public extension Model {
    /// We normally will refer to a `ComposableReadOnlyProperty` as `Model.ReadOnly` for succintness and clarity.
    typealias ReadOnly = AnyReadOnlyProperty<Value>
}
