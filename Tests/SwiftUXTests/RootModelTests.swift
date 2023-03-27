//
//  RootModelTests.swift
//  
//
//  Created by Óscar Morales Vivó on 3/26/23.
//

import SwiftUX
import XCTest

final class RootModelTests: XCTestCase {

    /// Sanity tests for root model behavior.
    func testRootModel() {
        let initialValue = "Potato"
        let secondValue = "Sweet Potato"

        var rootModel = Model.root(initialValue: "Potato")

        // Verify that `value` returns what we initialized with.
        XCTAssertEqual(rootModel.value, initialValue)

        let updateExpectation = expectation(description: "Update subscription called")

        // We need to capture `rootModel` explicitly as otherwise we're importing a reference that is modified during
        // modification.
        let subscription = rootModel.updates.sink { [rootModel] newValue in
            updateExpectation.fulfill()

            // Test that we're getting the value we expect.
            XCTAssertEqual(newValue, secondValue)

            // Verify that the value has already changed in `rootModel`. You shouldn't usually do this in real code.
            XCTAssertEqual(rootModel.value, secondValue)
        }

        rootModel.value = secondValue

        // Validate that setting... sets.
        XCTAssertEqual(rootModel.value, secondValue)

        waitForExpectations(timeout: 1.0)

        subscription.cancel()
    }
}
