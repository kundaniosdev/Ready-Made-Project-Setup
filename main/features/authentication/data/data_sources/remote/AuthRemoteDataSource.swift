//
//  AuthRemoteDataSource.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import Combine

// MARK: - Auth Remote Data Source Protocol
protocol AuthRemoteDataSource {
    func login(role: UserRole) -> AnyPublisher<AuthResponseDTO, Error>
    func loginWithEmail(email: String, password: String, role: UserRole) -> AnyPublisher<AuthResponseDTO, Error>
}

// MARK: - Auth Remote Data Source Implementation
final class AuthRemoteDataSourceImpl: AuthRemoteDataSource {
    // MARK: - Initialization
    init() {
        print("🟢[ARC] AuthRemoteDataSourceImpl ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] AuthRemoteDataSourceImpl DEALLOCATED")
    }
    
    // MARK: - Public Methods
    func login(role: UserRole) -> AnyPublisher<AuthResponseDTO, Error> {
        let userDto = UserDTO(
            id: UUID().uuidString,
            name: "\(role.rawValue) User",
            email: "\(role.rawValue.lowercased())@readymade.app",
            role: role.rawValue,
            avatarUrl: nil
        )
        let response = AuthResponseDTO(
            user: userDto,
            token: UUID().uuidString,
            refreshToken: UUID().uuidString
        )
        
        return Just(response)
            .setFailureType(to: Error.self)
            .delay(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func loginWithEmail(email: String, password: String, role: UserRole) -> AnyPublisher<AuthResponseDTO, Error> {
        let userDto = UserDTO(
            id: UUID().uuidString,
            name: "\(role.rawValue) User",
            email: email,
            role: role.rawValue,
            avatarUrl: nil
        )
        let response = AuthResponseDTO(
            user: userDto,
            token: UUID().uuidString,
            refreshToken: UUID().uuidString
        )
        
        return Just(response)
            .setFailureType(to: Error.self)
            .delay(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
