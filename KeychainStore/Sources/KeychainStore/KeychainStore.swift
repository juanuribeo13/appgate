//
//  KeychainStore.swift
//  
//
//  Created by Juan Uribe on 15/05/21.
//

import Foundation
import Security

/// Store for interacting with the keychain.
public final class KeychainStore: KeychainStoreProtocol {
    
    // MARK: - Properties
    
    private let service: String
    
    // MARK: - Initializers
    
    public init(
        service: String = "com.appgate.Appgate.Repository.KeychainStore") {
        self.service = service
    }
    
    // MARK: - Internal Functions
    
    public func add(username: String, password: String) -> Bool {
        guard let data = password.data(using: .utf8) else {
            return false
        }
        var query = query(username: username)
        query[kSecValueData] = data
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    public func fetchPassword(username: String) -> String? {
        var query = query(username: username)
        query[kSecReturnData] = true
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess,
              let data = result as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    public func deletePassword(username: String) -> Bool {
        let query = query(username: username) as CFDictionary
        return SecItemDelete(query) == errSecSuccess
    }
    
    // MARK: - Private Functions
    
    private func query(username: String) -> [CFString: Any] {
        [
            kSecAttrAccount: username,
            kSecAttrService: service,
            kSecClass: kSecClassGenericPassword
        ]
    }
}
