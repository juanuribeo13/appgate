//
//  AccountValidatorTests.swift
//  
//
//  Created by Juan Uribe on 15/05/21.
//

import XCTest
@testable import Core

final class AccountValidatorTests: XCTestCase {
    
    // MARK: - Username
    
    func testUsername_valid() {
        // Given
        let username = "juan@test.com"
        // When/Then
        XCTAssertNoThrow(try AccountValidator.valid(username: username))
    }
    
    func testUsername_invalid_missingAt() {
        assertInvalid(username: "juantest.com")
    }
    
    func testUsername_invalid_missingDot() {
        assertInvalid(username: "juan@testcom")
    }
    
    func testUsername_invalid_missingDomainName() {
        assertInvalid(username: "juan@.com")
    }
    
    func testUsername_invalid_missingTopLevelDomain() {
        assertInvalid(username: "juan@test.")
    }
    
    func testUsername_invalid_missingUsername() {
        assertInvalid(username: "@test.com")
    }
    
    // MARK: - Password
    
    func testPassword_valid() {
        // Given
        let password = "TestPassword1!"
        // When/Then
        XCTAssertNoThrow(try AccountValidator.valid(password: password))
    }
    
    func testUsername_invalid_lessThanEightChars() {
        assertInvalid(password: "Short1!")
    }
    
    func testUsername_invalid_missingLowerCase() {
        assertInvalid(password: "TESTPASSWORD1!")
    }
    
    func testUsername_invalid_missingUpperCase() {
        assertInvalid(password: "testpassword1!")
    }
    
    func testUsername_invalid_missingDigit() {
        assertInvalid(password: "TestPassword!")
    }
    
    func testUsername_invalid_missingSpecialCharacter() {
        assertInvalid(password: "TestPassword1")
    }
    
    // MARK: - Private Functions
    
    private func assertInvalid(username: String,
                               file: StaticString = #file,
                               line: UInt = #line) {
        do {
            try AccountValidator.valid(username: username)
            XCTFail("Expecting validation to fail but it was successful",
                    file: file,
                    line: line)
        } catch let error as AccountValidator.ValidationError {
            XCTAssertEqual(error, .invalidUsername, file: file, line: line)
        } catch {
            XCTFail("Expecting an AccountValidator.ValidationError",
                    file: file,
                    line: line)
        }
    }
    
    private func assertInvalid(password: String,
                               file: StaticString = #file,
                               line: UInt = #line) {
        do {
            try AccountValidator.valid(password: password)
            XCTFail("Expecting validation to fail but it was successful",
                    file: file,
                    line: line)
        } catch let error as AccountValidator.ValidationError {
            XCTAssertEqual(error, .invalidPassword, file: file, line: line)
        } catch {
            XCTFail("Expecting an AccountValidator.ValidationError",
                    file: file,
                    line: line)
        }
    }
}
