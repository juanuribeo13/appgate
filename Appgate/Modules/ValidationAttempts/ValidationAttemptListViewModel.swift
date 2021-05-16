//
//  ValidationAttemptListViewModel.swift
//  Appgate
//
//  Created by Juan Uribe on 16/05/21.
//

import Foundation
import Combine
import Core

final class ValidationAttemptListViewModel {
    
    // MARK: - Properties
    
    let items: [ValidationAttemptItemViewModel]
    
    // MARK: - Initializers
    
    init(validationAttempts: [ValidationAttempt]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        items = validationAttempts
            .sorted { $0.geoTimeZone.time > $1.geoTimeZone.time}
            .map { .init(attempt: $0, dateFormatter: dateFormatter) }
    }
}
