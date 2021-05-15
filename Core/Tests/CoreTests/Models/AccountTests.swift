//
//  AccountTests.swift
//  
//
//  Created by Juan Uribe on 15/05/21.
//

import XCTest
@testable import Core

final class AccountTests: XCTestCase {
    
    func testDecoding() throws {
        // Given
        let json = """
        {
            "username": "juan@test.com",
            "password": "TestPassword1!"
        }
        """
        let data = Data(json.utf8)
        
        // When
        let sut = try JSONDecoder().decode(Account.self, from: data)
        
        // Then
        XCTAssertEqual(sut.username, "juan@test.com")
        XCTAssertEqual(sut.password, "TestPassword1!")
    }
    
    func testEncoding() throws {
        // Given
        let account = Account(username: "juan@test.com",
                              password: "TestPassword1!")
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(account)
        guard let sut = try JSONSerialization
                .jsonObject(with: data, options: []) as? [String: Any] else {
            throw "Failed to get JSON object from encoded Account"
        }
        
        // Then
        XCTAssertEqual(sut["username"] as? String, "juan@test.com")
        XCTAssertEqual(sut["password"] as? String, "TestPassword1!")
    }
}
