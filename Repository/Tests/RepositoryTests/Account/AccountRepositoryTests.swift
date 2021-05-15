//
//  AccountRepositoryTests.swift
//  
//
//  Created by Juan Uribe on 15/05/21.
//

import XCTest
@testable import Repository

final class AccountRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: AccountRepository!
    var keychainStore: FakeKeychainStore!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        keychainStore = .init()
        sut = .init(keychainStore: keychainStore)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        keychainStore = nil
    }
    
    // MARK: - Tests
    
    func testAdd() {
        // Given
        XCTAssertFalse(keychainStore.addCalled)
        // When
        _ = sut.add(item: .init(username: "test@test.com",
                                password: "Password1!"))
        // Then
        XCTAssertTrue(keychainStore.addCalled)
    }
}
