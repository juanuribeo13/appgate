//
//  HomeViewModel.swift
//  Appgate
//
//  Created by Juan Uribe on 15/05/21.
//

import Foundation
import Combine
import Core
import Repository

final class HomeViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var isValidated: Bool = false
    @Published var username: String = ""
    @Published var password: String = ""
    @Published private(set) var isValid: Bool = false
    @Published var alert: SimpleAlert? = nil
    
    var validationAttemptsVM: ValidationAttemptListViewModel {
        .init(validationAttempts: validationAttempts)
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    private let accountRepository: AccountRepository
    private let locationManager: LocationManager
    private var validationAttempts: [ValidationAttempt] = []
    
    // MARK: - Initializers
    
    init() {
        accountRepository = .init()
        locationManager = .init()
        bind()
        // TODO: Remove test code
        username = "juan@test.com"
        password = "Password1!"
    }
    
    // MARK: - Internal Functions
    
    func createAccount() {
        isValidated = false
        let account = Account(username: username, password: password)
        guard accountRepository.add(item: account) else {
            alert = .init(title: "Error",
                          message: "There was an error creating the account :(")
            return
        }
        alert = .init(message: "Account successfully created!",
                      dismissAction: { [weak self] in
                        self?.username = ""
                        self?.password = ""
                      })
    }
    
    func validateAccount() {
        guard let location = locationManager.lastLocation else {
            alert = .init(title: "Error",
                          message: "No location available, please wait until we get your location or if permission was denied, please allow us access to your location to be able to use this feature.")
            return
        }
        let account = Account(username: username, password: password)
        accountRepository.validate(
            item: account,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude) { [weak self] result in
            switch result {
            case .success(let attempts):
                self?.validationAttempts = attempts
                self?.isValidated = true
            case .failure(let error):
                self?.isValidated = false
                switch error {
                case .generic, .failedGettingTimeZone:
                    self?.alert = .init(
                        title: "Error",
                        message: "Something went wrong, please try again later")
                case .invalidCredentials:
                    self?.alert = .init(title: "Error",
                                        message: "Invalid credentials")
                }
            }
        }
    }
    
    // MARK: - Private Functions
    
    private func bind() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
    
    private func isUsernameValid() -> AnyPublisher<Bool, Never> {
        $username
            .debounce(for: 0.5, scheduler: DispatchQueue.global())
            .removeDuplicates()
            .map { input in
                do {
                    try AccountValidator.valid(username: input)
                    return true
                } catch {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func isPasswordValid() -> AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.5, scheduler: DispatchQueue.global())
            .removeDuplicates()
            .map { input in
                do {
                    try AccountValidator.valid(password: input)
                    return true
                } catch {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isUsernameValid(), isPasswordValid())
            .map { usernameIsValid, passwordIsValid in
                usernameIsValid && passwordIsValid
            }
            .eraseToAnyPublisher()
    }
}
