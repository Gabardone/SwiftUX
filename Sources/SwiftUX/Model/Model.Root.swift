//
//  Model.Root.swift
//  Teibolto Classic
//
//  Created by Óscar Morales Vivó on 12/11/22.
//

import Combine
import Foundation

extension Model {
    /**
     Returns a WriteableModel that manages a value initialized with the given one.

     This model is the simplest to use as a root model for a hierarchy or simply as a modifiable model for simple
     implementations. There is no read-only version of this method as it doesn't make a ton of sense to have a root
     model property that cannot be modified, although you can still pass it in read-only controllers.
     - Parameter initialValue: The initial value of the model.
     - Returns: A read/write model property whose value is `initialValue`
     */
    public static func root(initialValue: Value) -> some ReadWrite<Value> {
        var storage = initialValue
        let subject = PassthroughSubject<Value, Never>()
        return ComposableReadWrite(updates: subject) {
            return storage
        } setter: { newValue in
            guard storage != newValue else { return }
            storage = newValue
            subject.send(newValue)
        }
    }
}
