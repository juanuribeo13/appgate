//
//  AccountRepositoryProtocol.swift
//  
//
//  Created by Juan Uribe on 16/05/21.
//

import Foundation
import Core

/// Protocol that describes the requirements for an account repository.
public protocol AccountRepositoryProtocol {
    
    /// Add a new account.
    /// - Parameter account: The account to add
    func add(account: Account) -> Bool
}
