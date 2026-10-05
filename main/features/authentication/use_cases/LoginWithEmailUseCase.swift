//
//  LoginWithEmailUseCase.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import Combine

// MARK: - Login Use Case Protocol
protocol LoginWithEmailUseCase {
    func execute(role: UserRole) -> AnyPublisher<User, Error>
    func execute(email: String, password: String, role: UserRole) -> AnyPublisher<User, Error>
}

// MARK: - Login Use Case Implementation
final class LoginWithEmailUseCaseImpl: LoginWithEmailUseCase {
    // MARK: - Properties
    private let repository: AuthRepository
    
    // MARK: - Initialization
    init(repository: AuthRepository = AuthRepositoryImpl()) {
        self.repository = repository
        print("🟢[ARC] LoginWithEmailUseCaseImpl ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] LoginWithEmailUseCaseImpl DEALLOCATED")
    }
    
    // MARK: - Public Methods
    func execute(role: UserRole) -> AnyPublisher<User, Error> {
        return repository.login(role: role)
    }
    
    func execute(email: String, password: String, role: UserRole) -> AnyPublisher<User, Error> {
        return repository.loginWithEmail(email: email, password: password, role: role)
    }
}
