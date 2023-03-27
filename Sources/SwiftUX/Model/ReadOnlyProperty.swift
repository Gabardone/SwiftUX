//
//  File.swift
//  
//
//  Created by Óscar Morales Vivó on 3/25/23.
//

import Combine
import Foundation

/**
 An abstraction of an observable read-only property.

 There's no `ReadOnlyProperty` & `ObservableProperty` pair because each can be expressed separately without declaring
 any new types. This protocol declares the encapsulation of both behaviors as that's what we'll want to model a view
 layer of the property vendor.

 While the protocol doesn't require implementations to be classes, the value held should be semantically treated as if
 by reference. In other words if you assign a property to a different `let` or `var`, they should both point to the
 same value and its `updates` publisher should be the same.
 */
public protocol ReadOnlyProperty<Value> {

    // MARK: - Types

    /**
     The value type held by the model. Adoption of `Equatable` is required to be able to easily short-circuit update
     loops.
     */
    associatedtype Value: Equatable

    typealias UpdatePublisher = Publisher<Value, Never>

    // MARK: - API

    /**
     Returns the current value of the property. When allowed, directly sets the value of the property

     The protocol makes no guarantees about concurrency safety (implementations may do so)
     */
    var value: Value { get }

    /**
     A publisher that calls its subscribers whenever the property value changes.

     Subscribing to this publisher will **not** cause the subscription to be called. In addition, the publisher will
     call its subscribers every time the value changes and _only_ when the value changes (in other words, there is no
     need to call `removeDuplicates` on the publisher before subscribing).

     Unlike `@Published`, at the time the subscribers are called `value` should already hold its new value.

     Beyond that the protocol makes no guarantees about the publisher's behavior beyond the baseline ones detailed in
     the Combine documentation, but an implementation may go beyond those as long as all points of use are in accord.
     */
    var updates: any UpdatePublisher { get }
}

extension Model {
    /// Typealias for a read-only model property.
    public typealias ReadOnly = ReadOnlyProperty where Value == Model.Value
}
