//
//  GeoTimeZoneRepositoryProtocol.swift
//  
//
//  Created by Juan Uribe on 16/05/21.
//

import Foundation
import Core

/// Describes the requirements for a GeoTimeZone repository.
protocol GeoTimeZoneRepositoryProtocol {
    
    /// Get a `GeoTimeZone` for the given coordinates.
    /// - Parameters:
    ///   - latitude: The latitude.
    ///   - longitude: The longitude.
    ///   - completion: Closure to call with the result.
    func get(
        latitude: Double,
        longitude: Double,
        completion: @escaping (Result<GeoTimeZone, Error>) -> Void)
}
