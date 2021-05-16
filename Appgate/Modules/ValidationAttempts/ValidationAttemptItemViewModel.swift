//
//  ValidationAttemptItemViewModel.swift
//  Appgate
//
//  Created by Juan Uribe on 16/05/21.
//

import Foundation
import Core

final class ValidationAttemptItemViewModel: Identifiable {
    
    // MARK: - Properties
    
    let id = UUID()
    let wasSuccessful: Bool
    let time: String
    let timeZone: String
    let country: String
    
    // MARK: - Initializers
    
    init(attempt: ValidationAttempt,
         dateFormatter: DateFormatter) {
        wasSuccessful = attempt.wasSuccessful
        time = "When: \(dateFormatter.string(from: attempt.geoTimeZone.time))"
        timeZone = "Time zone: \(attempt.geoTimeZone.id)"
        country = "Country: \(attempt.geoTimeZone.countryName)"
    }
}
