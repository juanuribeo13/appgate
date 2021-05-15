//
//  SimpleAlert.swift
//  Appgate
//
//  Created by Juan Uribe on 15/05/21.
//

import Foundation

/// Structure for presenting simple alerts.
struct SimpleAlert: Identifiable {
    
    // MARK: - Properties
    
    var id: UUID { .init() }
    var title: String
    var message: String
    var dismissText: String
    var dismissAction: (() -> Void)?
    
    // MARK: - Initializers
    
    init(title: String = "",
         message: String = "",
         dismissText: String = "OK",
         dismissAction: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.dismissText = dismissText
        self.dismissAction = dismissAction
    }
}
