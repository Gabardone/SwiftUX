//
//  Model.Root.swift
//
//
//  Created by Óscar Morales Vivó on 3/26/23.
//

import Combine
import Foundation

public extension Model.Writeable {
    /**
     Returns a Model.Writeable that manages a value initialized with the given one.

     This model is the simplest to use as a root model for a hierarchy or simply as a modifiable model for simple
     implementations. There is no read-only version of this method as it doesn't make a ton of sense to have a root
     model property that cannot be modified, although you can still pass it in read-only controllers.
     - Parameter initialValue: The initial value of the model.
     - Returns: A read/write model property whose value is `initialValue`
     */
    static func root(initialValue: Value) -> Self {
        var storage = initialValue
        let subject = PassthroughSubject<Value, Never>()
        return .init(updates: subject) {
            return storage
        } setter: { newValue in
            guard storage != newValue else { return }
            storage = newValue
            subject.send(newValue)
        }
    }
}
