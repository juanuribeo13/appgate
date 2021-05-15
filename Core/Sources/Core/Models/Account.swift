//
//  File.swift
//  
//
//  Created by Juan Uribe on 15/05/21.
//

import Foundation

/// The account model.
public struct Account: Model {
    
    // MARK: - Properties
    
    public let username: String
    public let password: String
    
    // MARK: - Initializers
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
