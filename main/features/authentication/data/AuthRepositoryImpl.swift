//
//  AuthRepositoryImpl.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import Combine

// MARK: - Auth Repository Implementation
final class AuthRepositoryImpl: AuthRepository {
    // MARK: - Properties
    private let remoteDataSource: AuthRemoteDataSource
    private let localDataSource: AuthLocalDataSource
    
    // MARK: - Initialization
    init(
        remoteDataSource: AuthRemoteDataSource = AuthRemoteDataSourceImpl(),
        localDataSource: AuthLocalDataSource = AuthLocalDataSourceImpl()
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        print("🟢[ARC] AuthRepositoryImpl ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] AuthRepositoryImpl DEALLOCATED")
    }
    
    // MARK: - AuthRepository Methods
    func login(role: UserRole) -> AnyPublisher<User, Error> {
        remoteDataSource.login(role: role)
            .map { [weak self] response in
                let (user, token) = response.toDomain()
                self?.localDataSource.saveUser(user)
                self?.localDataSource.saveToken(token)
                return user
            }
            .eraseToAnyPublisher()
    }
    
    func loginWithEmail(email: String, password: String, role: UserRole) -> AnyPublisher<User, Error> {
        remoteDataSource.loginWithEmail(email: email, password: password, role: role)
            .map { [weak self] response in
                let (user, token) = response.toDomain()
                self?.localDataSource.saveUser(user)
                self?.localDataSource.saveToken(token)
                return user
            }
            .eraseToAnyPublisher()
    }
    
    func getCurrentUser() -> User? {
        return localDataSource.getUser()
    }
    
    func logout() -> AnyPublisher<Void, Never> {
        localDataSource.clearSession()
        return Just(()).eraseToAnyPublisher()
    }
}
