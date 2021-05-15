//
//  KeychainStoreProtocol.swift
//  
//
//  Created by Juan Uribe on 15/05/21.
//

import Foundation

/// Protocol that describes the requisites for a KeychainStore.
public protocol KeychainStoreProtocol {
    
    /// Store the given username and password.
    /// - Parameters:
    ///   - username: The username.
    ///   - password: The password.
    /// - Returns: A boolean that indicates whether the operation was successful or not.
    func add(username: String, password: String) -> Bool
    
    /// Fetch the password for the given username.
    /// - Parameter username: The username.
    /// - Returns: The password associated with the given username or nil if none was found.
    func fetchPassword(username: String) -> String?
    
    /// Delete the password for the given username.
    /// - Parameter username: The username.
    /// - Returns: A boolean that indicates whether the operation was successful or not.
    func deletePassword(username: String) -> Bool
}
