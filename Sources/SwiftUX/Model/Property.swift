//
//  Property.swift
//
//
//  Created by Óscar Morales Vivó on 3/25/23.
//

import Combine
import Foundation

/**
 An abstraction of an observable, readable property.

 While controllers work on two configurable value types (`ReadOnlyProperty` and `WritableProperty`) having this
 protocol for both of them to adopt allows us to implement some common functionality for both types.

 While the protocol doesn't require implementations to be classes —in fact neither of the commonly used are—, the value
 held should be semantically treated as if by reference. In other words if you assign a property to a different `let` or
 `var`, they should both point to the same value and its `updates` publisher should be the same.
 */
public protocol Property<Value> {
    // MARK: - Types

    /**
     The value type held by the model. Adoption of `Equatable` is required to be able to easily short-circuit update
     loops.
     */
    associatedtype Value: Equatable

    /**
     Type of publisher vended by `updates`. Due to limitations of Swift existentials and Combine `eraseToAnyPublisher`
     may need to be used before operators can be applied to it.
     */
    typealias UpdatePublisher = any Publisher<Value, Never>

    // MARK: - API

    /**
     Returns the current value of the property.

     The protocol makes no guarantees about concurrency safety (implementations may do so)
     */
    var value: Value { get }

    /**
     A publisher that calls its subscribers whenever the property value changes.

     Subscribing to this publisher will **not** cause the subscription to be called. In addition, the publisher will
     call its subscribers every time the value changes and _only_ when the value changes (in other words, there is no
     need to call `removeDuplicates` on the publisher before subscribing).

     Unlike `@Published`, at the time the subscribers are called `value` should already have been updated.

     The protocol makes no guarantees about the publisher's behavior beyond the baseline ones detailed in the Combine
     documentation, but an implementation may go beyond those as long as all points of use are in accord.
     */
    var updates: UpdatePublisher { get }
}

public extension Property {
    /**
     Converter to explicit readonly model property type.

     Since most logic will deal with the explicit model property types, this allows us to quickly convert a read/write
     or editable type into a readonly one.
     - Returns: a readonly model property that references the same value as the caller, including update publisher
     behavior.
     */
    func readonly() -> ReadOnlyProperty<Value> {
        .init(updates: updates, getter: { self.value })
    }
}
