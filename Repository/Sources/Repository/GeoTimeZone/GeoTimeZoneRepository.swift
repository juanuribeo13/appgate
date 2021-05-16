//
//  GeoTimeZoneRepository.swift
//  
//
//  Created by Juan Uribe on 16/05/21.
//

import Foundation
import Core

/// Repository for GeoTimeZone.
final class GeoTimeZoneRepository: GeoTimeZoneRepositoryProtocol {
    
    // MARK: - Properties
    
    private let networkRequestManager: NetworkRequestManagerProtocol
    
    // MARK: - Initializers
    
    init(networkRequestManager: NetworkRequestManagerProtocol =
            NetworkRequestManager()) {
        self.networkRequestManager = networkRequestManager
    }
    
    // MARK: - Internal Functions
    
    func get(
        latitude: Double,
        longitude: Double,
        completion: @escaping (Result<GeoTimeZone, Error>) -> Void) {
        guard let url =
                URL(string: "http://api.geonames.org/timezoneJSON") else {
            completion(.failure(NSError()))
            return
        }
        networkRequestManager
            .makeRequest(url: url,
                         httpMethod: .GET,
                         parameters: ["lat": latitude,
                                      "lng": longitude,
                                      "username": "qa_mobile_easy"],
                         modelType: GeoTimeZone.self, completion: completion)
    }
}
