//
//  FakeKeychainStore.swift
//  
//
//  Created by Juan Uribe on 15/05/21.
//

import Foundation
import KeychainStore

final class FakeKeychainStore: KeychainStoreProtocol {
    
    var addStub = false
    private(set) var addCalled = false
    func add(username: String, password: String) -> Bool {
        addCalled = true
        return addStub
    }
    
    var fetchPasswordStub: String? = nil
    private(set) var fetchPasswordCalled = false
    func fetchPassword(username: String) -> String? {
        fetchPasswordCalled = true
        return fetchPasswordStub
    }
    
    var deletePasswordStub = false
    private(set) var deletePasswordCalled = false
    func deletePassword(username: String) -> Bool {
        deletePasswordCalled = true
        return deletePasswordStub
    }
}
