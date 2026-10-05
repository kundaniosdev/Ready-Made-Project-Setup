//
//  RegisterUserUseCase.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import Combine

// MARK: - Register User Use Case Protocol
protocol RegisterUserUseCase {
    func execute(name: String, email: String, password: String, role: UserRole) -> AnyPublisher<User, Error>
}

// MARK: - Register User Use Case Implementation
final class RegisterUserUseCaseImpl: RegisterUserUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository = AuthRepositoryImpl()) {
        self.repository = repository
        print("🟢[ARC] RegisterUserUseCaseImpl ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] RegisterUserUseCaseImpl DEALLOCATED")
    }
    
    func execute(name: String, email: String, password: String, role: UserRole) -> AnyPublisher<User, Error> {
        return repository.loginWithEmail(email: email, password: password, role: role)
    }
}
