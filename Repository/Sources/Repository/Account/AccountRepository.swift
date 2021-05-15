//
//  AccountRepository.swift
//  
//
//  Created by Juan Uribe on 15/05/21.
//

import Foundation
import Core
import KeychainStore

/// Repository for accounts.
public final class AccountRepository: Repository {
    public typealias Model = Account
    
    // MARK: - Properties
    
    private let keychainStore: KeychainStoreProtocol
    
    // MARK: - Initializers
    
    init(keychainStore: KeychainStoreProtocol) {
        self.keychainStore = keychainStore
    }
    
    // MARK: - Public Functions
    
    public func add(item: Account) -> Bool {
        keychainStore.add(username: item.username, password: item.password)
    }
}
