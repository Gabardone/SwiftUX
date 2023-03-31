//
//  ControllerProtocol.swift
//
//
//  Created by Óscar Morales Vivó on 3/30/23.
//

import Foundation

/**
 Base protocol declaring standard Controller types and behaviors.

 While there should be no good reason to use anything other than subclasses of `Controller` to fulfill the role of this
 protocol, having it declared allow us to facilitate the declaration of common functionality with much more ease.
 */
@MainActor
public protocol ControllerProtocol: Identifiable {
    associatedtype ModelProperty: ReadOnlyProperty

    var modelProperty: ModelProperty { get }
}
