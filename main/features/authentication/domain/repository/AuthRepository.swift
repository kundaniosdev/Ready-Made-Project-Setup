//
//  AuthRepository.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import Combine

// MARK: - Auth Repository Protocol
protocol AuthRepository {
    func login(role: UserRole) -> AnyPublisher<User, Error>
    func loginWithEmail(email: String, password: String, role: UserRole) -> AnyPublisher<User, Error>
    func getCurrentUser() -> User?
    func logout() -> AnyPublisher<Void, Never>
}
