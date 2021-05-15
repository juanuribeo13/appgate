//
//  Repository.swift
//  
//
//  Created by Juan Uribe on 15/05/21.
//

import Foundation
import Core

/// Protocol that describes the requisites for a repository
public protocol Repository {
    associatedtype Model
    
    /// Add the given item.
    /// - Parameter item: The item to add
    /// - Returns: A boolean that indicates whether the operation was successful or not.
    func add(item: Model) -> Bool
}
