//
//  AccountValidator.swift
//  
//
//  Created by Juan Uribe on 15/05/21.
//

import Foundation

/// Validator for accounts.
public final class AccountValidator {
    
    public enum ValidationError: Error {
        case invalidUsername
        case invalidPassword
    }

    // MARK: - Public Functions
    
    /// Validates the given username.
    /// - Parameter username: The username.
    /// - Throws: A `ValidationError` in case the given value is invalid.
    public static func valid(username: String) throws {
        do {
            let regex = try NSRegularExpression(
                pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
                options: .caseInsensitive)
            if regex.firstMatch(
                in: username,
                options: NSRegularExpression.MatchingOptions(rawValue: 0),
                range: NSMakeRange(0, username.count)) == nil {
                throw ValidationError.invalidUsername
            }
        } catch {
            throw ValidationError.invalidUsername
        }
    }
    
    /// Validates the given password.
    /// - Parameter password: The password.
    /// - Throws: A `ValidationError` in case the given value is invalid.
    public static func valid(password: String) throws {
        let specialCharacterSet = CharacterSet.uppercaseLetters
            .union(.lowercaseLetters)
            .union(.decimalDigits)
            .inverted
        guard password.count >= 8,
              password.rangeOfCharacter(from: .uppercaseLetters) != nil,
              password.rangeOfCharacter(from: .lowercaseLetters) != nil,
              password.rangeOfCharacter(from: .decimalDigits) != nil,
              password.rangeOfCharacter(from: specialCharacterSet) != nil else {
            throw ValidationError.invalidPassword
        }
    }
}
