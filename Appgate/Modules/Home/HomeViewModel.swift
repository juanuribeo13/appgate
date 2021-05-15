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
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published private(set) var isValid: Bool = false
    @Published var alert: SimpleAlert? = nil
    
    private var cancellableSet: Set<AnyCancellable> = []
    private let accountRepository: AccountRepository
    
    // MARK: - Initializers
    
    init() {
        accountRepository = .init()
        bind()
    }
    
    // MARK: - Public Functions
    
    func createAccount() {
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
