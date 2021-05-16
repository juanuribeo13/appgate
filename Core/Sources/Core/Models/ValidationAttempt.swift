//
//  ValidationAttempt.swift
//  
//
//  Created by Juan Uribe on 16/05/21.
//

import Foundation

/// Model for a validation attempt.
public struct ValidationAttempt: Model {
    
    // MARK: - Properties
    
    public let wasSuccessful: Bool
    public let username: String
    public let geoTimeZone: GeoTimeZone
    
    // MARK: - Initializers
    
    public init(wasSuccessful: Bool,
                username: String,
                geoTimeZone: GeoTimeZone) {
        self.wasSuccessful = wasSuccessful
        self.username = username
        self.geoTimeZone = geoTimeZone
    }
}
