//
//  AccountRepository.swift
//  
//
//  Created by Juan Uribe on 15/05/21.
//

import Foundation
import Core
import KeychainStore

/// Repository for accounts.
public final class AccountRepository: AccountRepositoryProtocol {
    
    public enum Error: Swift.Error {
        case generic
        case invalidCredentials
        case failedGettingTimeZone
    }
    
    // MARK: - Properties
    
    private let keychainStore: KeychainStoreProtocol
    private let userDefaults: UserDefaults
    private let geoTimeZoneRepository: GeoTimeZoneRepositoryProtocol
    
    // MARK: - Initializers
    
    init(keychainStore: KeychainStoreProtocol,
         geoTimeZoneRepository: GeoTimeZoneRepositoryProtocol,
         userDefaults: UserDefaults) {
        self.keychainStore = keychainStore
        self.geoTimeZoneRepository = geoTimeZoneRepository
        self.userDefaults = userDefaults
    }
    
    public convenience init(
        keychainStore: KeychainStoreProtocol = KeychainStore()) {
        self.init(keychainStore: keychainStore,
                  geoTimeZoneRepository: GeoTimeZoneRepository(),
                  userDefaults: .standard)
    }
    
    // MARK: - Public Functions
    
    public func add(account: Account) -> Bool {
        keychainStore.add(username: account.username,
                          password: account.password)
    }
    
    /// Validate the given account.
    /// - Parameters:
    ///   - item: The account to validate.
    ///   - latitude: The device latitude.
    ///   - longitude: The device longitude.
    ///   - completion: Closure to call with the result, if successful an array of validation attempts will
    ///   be given back
    public func validate(
        item: Account,
        latitude: Double,
        longitude: Double,
        completion: @escaping (Result<[ValidationAttempt], Error>) -> Void) {
        geoTimeZoneRepository.get(latitude: latitude,
                                  longitude: longitude) { [weak self] result in
            guard let strongSelf = self else {
                completion(.failure(.generic))
                return
            }
            switch result {
            case .success(let timeZone):
                let password = strongSelf.keychainStore.fetchPassword(
                    username: item.username)
                let isSuccessful = password == item.password
                let attempt = ValidationAttempt(wasSuccessful: isSuccessful,
                                                username: item.username,
                                                geoTimeZone: timeZone)
                
                let attempts = strongSelf.storeValidationAttempt(attempt)
                if isSuccessful {
                    completion(.success(attempts))
                } else {
                    completion(.failure(.invalidCredentials))
                }
            case .failure:
                completion(.failure(.failedGettingTimeZone))
            }
        }
    }
    
    // MARK: - Public Functions
    
    private func storeValidationAttempt(
        _ validationAttempt: ValidationAttempt) -> [ValidationAttempt] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let key = "ValidationAttempts-\(validationAttempt.username)"
        
        var attempts = fetchValidationAttempts(key: key,
                                               dateFormatter: dateFormatter)
        attempts.append(validationAttempt)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        do {
            let data = try encoder.encode(attempts)
            userDefaults.setValue(data, forKey: key)
        } catch {}
        
        return attempts
    }
    
    private func fetchValidationAttempts(
        key: String, dateFormatter: DateFormatter) -> [ValidationAttempt] {
        guard let storedData = userDefaults.data(forKey: key) else {
            return []
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        do {
            return try decoder.decode([ValidationAttempt].self,
                                      from: storedData)
        } catch {
            return []
        }
    }
}
