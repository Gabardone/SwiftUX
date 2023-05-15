//
//  ReadOnlyPropertyTests.swift
//
//
//  Created by Óscar Morales Vivó on 3/28/23.
//

import SwiftUX
import XCTest

final class ReadOnlyPropertyTests: XCTestCase {
    /// Checks that a readonly version of an existing model property still gets the right value and updates the same.
    func testReadonlyBehavior() {
        let initialValue = "Potato"
        let laterValue = "Chocolate Milk"
        let rootModelProperty = WritableProperty.root(initialValue: initialValue)

        let readonlyProperty = rootModelProperty.readonly()
        XCTAssertEqual(readonlyProperty.value, initialValue)

        let rootUpdateExpectation = expectation(description: "Root property got updated")
        let rootSubscription = rootModelProperty.updates.sink { [rootModelProperty] newValue in
            rootUpdateExpectation.fulfill()

            XCTAssertEqual(newValue, laterValue)

            XCTAssertEqual(rootModelProperty.value, laterValue)
        }

        let readonlyExpectation = expectation(description: "Readonly property got updated")
        let readonlySubscription = readonlyProperty.updates.sink { newValue in
            readonlyExpectation.fulfill()

            XCTAssertEqual(newValue, laterValue)

            XCTAssertEqual(readonlyProperty.value, laterValue)
        }

        rootModelProperty.value = laterValue
        XCTAssertEqual(rootModelProperty.value, laterValue)
        XCTAssertEqual(readonlyProperty.value, laterValue)

        waitForExpectations(timeout: 0.5)

        readonlySubscription.cancel()
        rootSubscription.cancel()
    }
}
