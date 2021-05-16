//
//  GeoTimeZone.swift
//  
//
//  Created by Juan Uribe on 16/05/21.
//

import Foundation

/// Represents a GeoTimeZone
public struct GeoTimeZone: Model {
    
    // MARK: - Properties
    
    /// The name of the timezone (according to Olson).
    public let id: String
    /// The name of the country.
    public let countryName: String
    /// The ISO code for the country.
    public let countryCode: String
    /// The latitude.
    public let latitude: Double
    /// The longitude.
    public let longitude: Double
    /// The local current time.
    public let time: Date
    
    // MARK: Codable
    
    enum CodingKeys: String, CodingKey {
        case id = "timezoneId"
        case countryName
        case countryCode
        case latitude = "lat"
        case longitude = "lng"
        case time
    }
    
    // MARK: - Initializers
    
    public init(id: String,
                countryName: String,
                countryCode: String,
                latitude: Double,
                longitude: Double,
                time: Date) {
        self.id = id
        self.countryName = countryName
        self.countryCode = countryCode
        self.latitude = latitude
        self.longitude = longitude
        self.time = time
    }
}
