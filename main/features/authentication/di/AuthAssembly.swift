//
//  AuthAssembly.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import SwiftUI

// MARK: - Auth Assembly
final class AuthAssembly {
    static let shared = AuthAssembly()
    
    private init() {
        print("🟢[ARC] AuthAssembly ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] AuthAssembly DEALLOCATED")
    }
    
    // MARK: - Repositories
    func makeAuthRepository() -> AuthRepository {
        let remoteDataSource = AuthRemoteDataSourceImpl()
        let localDataSource = AuthLocalDataSourceImpl()
        return AuthRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
    }
    
    // MARK: - Use Cases
    func makeLoginUseCase() -> LoginWithEmailUseCase {
        return LoginWithEmailUseCaseImpl(repository: makeAuthRepository())
    }
    
    func makeRegisterUseCase() -> RegisterUserUseCase {
        return RegisterUserUseCaseImpl(repository: makeAuthRepository())
    }
    
    func makeVerifyOTPUseCase() -> VerifyOTPUseCase {
        return VerifyOTPUseCaseImpl()
    }
    
    func makeResetPasswordUseCase() -> ResetPasswordUseCase {
        return ResetPasswordUseCaseImpl()
    }
    
    // MARK: - View Models
    func makeLoginViewModel(
        router: Router<AuthRoute>,
        onLoginSuccess: @escaping (User) -> Void
    ) -> LoginViewModel {
        return LoginViewModel(
            loginUseCase: makeLoginUseCase(),
            router: router,
            onLoginSuccess: onLoginSuccess
        )
    }
}
