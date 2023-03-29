//
//  Model.swift
//  
//
//  Created by Óscar Morales Vivó on 3/26/23.
//

import Foundation


/**
 Namespace `enum` for model types, protocols and utilities.
 */
public enum Model<Value: Equatable> {
    /**
     The model's value type. Should usually be a… value type. Reference types may work as well but are not recommended
     due to unexpected side effects and mutability.
     */
    public typealias Value = Value
}
