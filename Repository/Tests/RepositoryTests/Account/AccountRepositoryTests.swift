//
//  AccountRepositoryTests.swift
//  
//
//  Created by Juan Uribe on 15/05/21.
//

import XCTest
import Core
@testable import Repository

final class AccountRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: AccountRepository!
    var keychainStore: FakeKeychainStore!
    var networkRequestManager: FakeNetworkRequestManager!
    var userDefaults: FakeUserDefaults!
    
    let account = Account(username: "test@test.com", password: "Password1!")
    var time: Date!
    var stubTimeZone: GeoTimeZone!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        keychainStore = .init()
        networkRequestManager = .init()
        userDefaults = .init()
        sut = .init(keychainStore: keychainStore,
                    networkRequestManager: networkRequestManager,
                    userDefaults: userDefaults)
        
        time = Date()
        stubTimeZone = GeoTimeZone(id: "Europe/Vienna",
                                   countryName: "Austria",
                                   countryCode: "AT",
                                   latitude: 47.7,
                                   longitude: 10.2,
                                   time: time)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        keychainStore = nil
        networkRequestManager = nil
        userDefaults = nil
        
        time = nil
        stubTimeZone = nil
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
    
    func testValidate_valid_withoutPreviousAttempts() {
        // Given
        XCTAssertFalse(keychainStore.fetchPasswordCalled)
        XCTAssertFalse(networkRequestManager.makeRequestCalled)
        XCTAssertFalse(userDefaults.dataForKeyCalled)
        XCTAssertFalse(userDefaults.setValueCalled)
        
        keychainStore.fetchPasswordStub = account.password
        networkRequestManager.stubResponse = .success(stubTimeZone)
        userDefaults.dataForKeyStubData = nil
        
        // When
        let expectation = XCTestExpectation()
        sut.validate(item: account,
                     latitude: stubTimeZone.latitude,
                     longitude: stubTimeZone.longitude) { result in
            // Then
            switch result {
            case .success(let attempts):
                XCTAssertEqual(attempts.count, 1)
                let attempt = attempts[0]
                XCTAssertTrue(attempt.wasSuccessful)
                XCTAssertEqual(attempt.username, self.account.username)
                XCTAssertEqual(attempt.geoTimeZone.time, self.time)
            case .failure:
                XCTFail("Expecting validation to be successful")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testValidate_valid_withPreviousAttempts() {
        // Given
        XCTAssertFalse(keychainStore.fetchPasswordCalled)
        XCTAssertFalse(networkRequestManager.makeRequestCalled)
        XCTAssertFalse(userDefaults.dataForKeyCalled)
        XCTAssertFalse(userDefaults.setValueCalled)
        
        keychainStore.fetchPasswordStub = account.password
        networkRequestManager.stubResponse = .success(stubTimeZone)
        
        
        let attempts: [ValidationAttempt] = [
            .init(wasSuccessful: false,
                  username: account.username,
                  geoTimeZone: stubTimeZone),
            .init(wasSuccessful: true,
                  username: account.username,
                  geoTimeZone: stubTimeZone)
        ]
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        userDefaults.dataForKeyStubData = try? encoder.encode(attempts)
        
        // When
        let expectation = XCTestExpectation()
        sut.validate(item: account,
                     latitude: stubTimeZone.latitude,
                     longitude: stubTimeZone.longitude) { result in
            // Then
            switch result {
            case .success(let attempts):
                XCTAssertEqual(attempts.count, 3)
            case .failure:
                XCTFail("Expecting validation to be successful")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testValidate_invalid() {
        // Given
        XCTAssertFalse(keychainStore.fetchPasswordCalled)
        XCTAssertFalse(networkRequestManager.makeRequestCalled)
        XCTAssertFalse(userDefaults.dataForKeyCalled)
        XCTAssertFalse(userDefaults.setValueCalled)
        
        keychainStore.fetchPasswordStub = "AnotherPass2@"
        networkRequestManager.stubResponse = .success(stubTimeZone)
        userDefaults.dataForKeyStubData = nil
        
        // When
        let expectation = XCTestExpectation()
        sut.validate(item: account,
                     latitude: stubTimeZone.latitude,
                     longitude: stubTimeZone.longitude) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expecting validation to fail")
            case .failure(let error):
                XCTAssertEqual(error, .invalidCredentials)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
