//
//  KeyPathModelTests.swift
//
//
//  Created by Óscar Morales Vivó on 3/27/23.
//

import SwiftUX
import XCTest

final class KeyPathModelTests: XCTestCase {
    private struct Dummy: Equatable {
        var string: String

        var integer: Int
    }

    /// Tests that a read-only keypath model updates as expected when its parent does.
    func testReadOnlyKeyPathModel() {
        let initialValue = Dummy(string: "Potato", integer: 7)
        let secondValue = Dummy(string: "No Potato", integer: 0)
        var rootModel = Model.Writeable.root(initialValue: initialValue)

        // We need to capture `rootModel` explicitly as otherwise we're importing a reference that is modified during
        // modification.
        let rootUpdateExpectation = expectation(description: "Root model property was updated")
        let rootSubscription = rootModel.updates.sink { [rootModel] newValue in
            rootUpdateExpectation.fulfill()

            // Test that we're getting the value we expect.
            XCTAssertEqual(newValue, secondValue)

            // Verify that the value has already changed in `rootModel`. You shouldn't usually do this in real code.
            XCTAssertEqual(rootModel.value, secondValue)
        }

        let stringKeyPath = \Dummy.string
        let stringModel = rootModel.readOnlyKeyPath(stringKeyPath)
        let stringExpectation = expectation(description: "String keypath model property was updated")
        let stringSubscription = stringModel.updates.sink { [rootModel, stringModel] newValue in
            stringExpectation.fulfill()

            // Test that we're getting the value we expect.
            XCTAssertEqual(newValue, secondValue[keyPath: stringKeyPath])

            // Verify that the value has already changed in `rootModel`. You shouldn't usually do this in real code.
            XCTAssertEqual(rootModel.value, secondValue)

            // Verify that the value has already changed in `stringModel`. You shouldn't usually do this in real code.
            XCTAssertEqual(stringModel.value, secondValue[keyPath: stringKeyPath])
        }

        let integerKeyPath = \Dummy.integer
        let integerModel = rootModel.readOnlyKeyPath(integerKeyPath)
        let integerExpectation = expectation(description: "Integer keypath model property was updated")
        let integerSubscription = integerModel.updates.sink { [rootModel, integerModel] newValue in
            integerExpectation.fulfill()

            // Test that we're getting the value we expect.
            XCTAssertEqual(newValue, secondValue[keyPath: integerKeyPath])

            // Verify that the value has already changed in `rootModel`. You shouldn't usually do this in real code.
            XCTAssertEqual(rootModel.value, secondValue)

            // Verify that the value has already changed in `integerModel`. You shouldn't usually do this in real code.
            XCTAssertEqual(integerModel.value, secondValue[keyPath: integerKeyPath])
        }

        rootModel.value = secondValue

        waitForExpectations(timeout: 1.0)

        integerSubscription.cancel()
        stringSubscription.cancel()
        rootSubscription.cancel()
    }

    /// Tests that a read/write keypath model updates as expected when its parent does.
    func testReadWriteKeyPathModelParentalChangePropagation() {
        let initialValue = Dummy(string: "Potato", integer: 7)
        let secondValue = Dummy(string: "No Potato", integer: 0)
        var rootModel = Model.Writeable.root(initialValue: initialValue)

        // We need to capture `rootModel` explicitly as otherwise we're importing a reference that is modified during
        // modification.
        let rootUpdateExpectation = expectation(description: "Root model property was updated")
        let rootSubscription = rootModel.updates.sink { [rootModel] newValue in
            rootUpdateExpectation.fulfill()

            // Test that we're getting the value we expect.
            XCTAssertEqual(newValue, secondValue)

            // Verify that the value has already changed in `rootModel`. You shouldn't usually do this in real code.
            XCTAssertEqual(rootModel.value, secondValue)
        }

        let stringKeyPath = \Dummy.string
        let stringModel = rootModel.writableKeyPath(stringKeyPath)
        let stringExpectation = expectation(description: "String keypath model property was updated")
        let stringSubscription = stringModel.updates.sink { [rootModel, stringModel] newValue in
            stringExpectation.fulfill()

            // Test that we're getting the value we expect.
            XCTAssertEqual(newValue, secondValue[keyPath: stringKeyPath])

            // Verify that the value has already changed in `rootModel`. You shouldn't usually do this in real code.
            XCTAssertEqual(rootModel.value, secondValue)

            // Verify that the value has already changed in `stringModel`. You shouldn't usually do this in real code.
            XCTAssertEqual(stringModel.value, secondValue[keyPath: stringKeyPath])
        }

        let integerKeyPath = \Dummy.integer
        let integerModel = rootModel.writableKeyPath(integerKeyPath)
        let integerExpectation = expectation(description: "Integer keypath model property was updated")
        let integerSubscription = integerModel.updates.sink { [rootModel, integerModel] newValue in
            integerExpectation.fulfill()

            // Test that we're getting the value we expect.
            XCTAssertEqual(newValue, secondValue[keyPath: integerKeyPath])

            // Verify that the value has already changed in `rootModel`. You shouldn't usually do this in real code.
            XCTAssertEqual(rootModel.value, secondValue)

            // Verify that the value has already changed in `integerModel`. You shouldn't usually do this in real code.
            XCTAssertEqual(integerModel.value, secondValue[keyPath: integerKeyPath])
        }

        rootModel.value = secondValue

        waitForExpectations(timeout: 1.0)

        integerSubscription.cancel()
        stringSubscription.cancel()
        rootSubscription.cancel()
    }

    /// Tests that a read/write keypath model's parent updates as expected when the keypath model is updated.
    func testReadWriteKeyPathModelChangePropagation() {
        let initialValue = Dummy(string: "Potato", integer: 7)
        let secondValue = Dummy(string: "No Potato", integer: 7)
        let thirdValue = Dummy(string: "No Potato", integer: 0)
        let rootModel = Model.Writeable.root(initialValue: initialValue)

        // We need to capture `rootModel` explicitly as otherwise we're importing a reference that is modified during
        // modification.
        let rootUpdateExpectation = expectation(description: "Root model property was updated")
        rootUpdateExpectation.expectedFulfillmentCount = 2 // Expect to get two calls here.
        var secondPass = false
        let rootSubscription = rootModel.updates.sink { newValue in
            rootUpdateExpectation.fulfill()

            let expectedValue = secondPass ? thirdValue : secondValue
            secondPass = true
            // Test that we're getting the value we expect.
            XCTAssertEqual(newValue, expectedValue)

            // Verify that the value has already changed in `rootModel`. You shouldn't usually do this in real code.
            XCTAssertEqual(rootModel.value, expectedValue)
        }

        let stringKeyPath = \Dummy.string
        var stringModel = rootModel.writableKeyPath(stringKeyPath)
        let stringExpectation = expectation(description: "String keypath model property was updated")
        let stringSubscription = stringModel.updates.sink { [rootModel] newValue in
            stringExpectation.fulfill()

            // Test that we're getting the value we expect.
            XCTAssertEqual(newValue, secondValue[keyPath: stringKeyPath])

            // Verify that the value has already changed in `rootModel`. You shouldn't usually do this in real code.
            XCTAssertEqual(rootModel.value, secondValue)
        }

        let integerKeyPath = \Dummy.integer
        var integerModel = rootModel.writableKeyPath(integerKeyPath)
        let integerExpectation = expectation(description: "Integer keypath model property was updated")
        let integerSubscription = integerModel.updates.sink { [rootModel] newValue in
            integerExpectation.fulfill()

            // Test that we're getting the value we expect.
            XCTAssertEqual(newValue, thirdValue[keyPath: integerKeyPath])

            // Verify that the value has already changed in `rootModel`. You shouldn't usually do this in real code.
            XCTAssertEqual(rootModel.value, thirdValue)
        }

        stringModel.value = secondValue.string
        XCTAssertEqual(stringModel.value, secondValue.string)

        integerModel.value = thirdValue.integer
        XCTAssertEqual(integerModel.value, thirdValue.integer)

        waitForExpectations(timeout: 1.0)

        integerSubscription.cancel()
        stringSubscription.cancel()
        rootSubscription.cancel()
    }

    /// Checks that updates on a keypath model property with the same value cause no update callbacks.
    func testEqualityDoesNotUpdateAnyone() {
        let initialValue = Dummy(string: "Potato", integer: 7)
        let rootModel = Model.Writeable.root(initialValue: initialValue)

        // We need to capture `rootModel` explicitly as otherwise we're importing a reference that is modified during
        // modification.
        let rootUpdateExpectation = expectation(description: "Root model property was updated")
        rootUpdateExpectation.isInverted = true
        let rootSubscription = rootModel.updates.sink { _ in
            rootUpdateExpectation.fulfill()
        }

        let stringKeyPath = \Dummy.string
        var stringModel = rootModel.writableKeyPath(stringKeyPath)
        let stringExpectation = expectation(description: "String keypath model property was updated")
        stringExpectation.isInverted = true
        let stringSubscription = stringModel.updates.sink { _ in
            stringExpectation.fulfill()
        }

        let integerKeyPath = \Dummy.integer
        var integerModel = rootModel.writableKeyPath(integerKeyPath)
        let integerExpectation = expectation(description: "Integer keypath model property was updated")
        integerExpectation.isInverted = true
        let integerSubscription = integerModel.updates.sink { _ in
            integerExpectation.fulfill()
        }

        stringModel.value = initialValue.string
        integerModel.value = initialValue.integer

        waitForExpectations(timeout: 0.5)

        integerSubscription.cancel()
        stringSubscription.cancel()
        rootSubscription.cancel()
    }
}
