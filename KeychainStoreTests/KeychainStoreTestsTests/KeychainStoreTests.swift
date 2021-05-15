//
//  KeychainStoreTests.swift
//  
//
//  Created by Juan Uribe on 15/05/21.
//

import XCTest
import KeychainStore

final class KeychainStoreTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: KeychainStore!
    let username = "username@test.com"
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        sut = KeychainStore(
            service: "com.appgate.Appgate.Repository.KeychainStoreTests")
    }
    
    override func tearDown() {
        super.tearDown()
        _ = sut.deletePassword(username: username)
        sut = nil
    }
    
    // MARK: - Tests
    
    func testAddSuccess() {
        // When
        let result = sut.add(username: username, password: "testPassword")
        // Then
        XCTAssertTrue(result)
    }
    
    func testAddFailure() {
        // Given
        let firstResult = sut.add(username: username, password: "testPassword")
        XCTAssertTrue(firstResult)
        // When
        let result = sut.add(username: username, password: "testPassword")
        // Then
        XCTAssertFalse(result)
    }
    
    func testFetchSuccess() {
        // Given
        let password = "testPassword"
        let addResult = sut.add(username: username, password: password)
        XCTAssertTrue(addResult)
        // When
        let result = sut.fetchPassword(username: username)
        // Then
        XCTAssertEqual(result, password)
    }
    
    func testFetchNotFound() {
        // When
        let result = sut.fetchPassword(username: username)
        // Then
        XCTAssertNil(result)
    }
    
    func testDeleteSuccess() {
        // Given
        let addResult = sut.add(username: username, password: "testPassword")
        XCTAssertTrue(addResult)
        // When
        let result = sut.deletePassword(username: username)
        // Then
        XCTAssertTrue(result)
    }
    
    func testDeleteNotFound() {
        // When
        let result = sut.deletePassword(username: username)
        // Then
        XCTAssertFalse(result)
    }
}
