//
//  AuthLocalDataSource.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation

// MARK: - Auth Local Data Source Protocol
protocol AuthLocalDataSource {
    func saveUser(_ user: User)
    func getUser() -> User?
    func saveToken(_ token: AuthToken)
    func getToken() -> AuthToken?
    func clearSession()
}

// MARK: - Auth Local Data Source Implementation
final class AuthLocalDataSourceImpl: AuthLocalDataSource {
    // MARK: - Properties
    private let userDefaults: UserDefaults
    private let userKey = "com.readymade.current_user"
    private let tokenKey = "com.readymade.auth_token"
    
    // MARK: - Initialization
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        print("🟢[ARC] AuthLocalDataSourceImpl ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] AuthLocalDataSourceImpl DEALLOCATED")
    }
    
    // MARK: - Public Methods
    func saveUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            userDefaults.set(data, forKey: userKey)
        }
    }
    
    func getUser() -> User? {
        guard let data = userDefaults.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    func saveToken(_ token: AuthToken) {
        if let data = try? JSONEncoder().encode(token) {
            userDefaults.set(data, forKey: tokenKey)
        }
    }
    
    func getToken() -> AuthToken? {
        guard let data = userDefaults.data(forKey: tokenKey),
              let token = try? JSONDecoder().decode(AuthToken.self, from: data) else {
            return nil
        }
        return token
    }
    
    func clearSession() {
        userDefaults.removeObject(forKey: userKey)
        userDefaults.removeObject(forKey: tokenKey)
    }
}
