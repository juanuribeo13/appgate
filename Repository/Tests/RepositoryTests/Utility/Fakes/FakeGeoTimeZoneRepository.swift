//
//  File.swift
//  
//
//  Created by Juan Uribe on 16/05/21.
//

import Foundation
import Core
@testable import Repository

final class FakeGeoTimeZoneRepository: GeoTimeZoneRepositoryProtocol {
    
    private(set) var getCalled = false
    var getResultStub: Result<GeoTimeZone, Error> = .failure(NSError())
    func get(latitude: Double,
             longitude: Double,
             completion: @escaping (Result<GeoTimeZone, Error>) -> Void) {
        getCalled = true
        completion(getResultStub)
    }
}
