//
//  LoginViewModel.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import Combine

// MARK: - Login View Model
final class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var selectedRole: UserRole = .student
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private let loginUseCase: LoginWithEmailUseCase
    private let router: Router<AuthRoute>
    private let onLoginSuccess: (User) -> Void
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(
        loginUseCase: LoginWithEmailUseCase = AuthAssembly.shared.makeLoginUseCase(),
        router: Router<AuthRoute> = Router<AuthRoute>(),
        onLoginSuccess: @escaping (User) -> Void = { _ in }
    ) {
        self.loginUseCase = loginUseCase
        self.router = router
        self.onLoginSuccess = onLoginSuccess
        print("🟢[ARC] LoginViewModel ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] LoginViewModel DEALLOCATED")
    }
    
    // MARK: - Public Methods
    func login(as role: UserRole) {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        selectedRole = role
        
        loginUseCase.execute(role: role)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.onLoginSuccess(user)
            }
            .store(in: &cancellables)
    }
    
    func loginWithCredentials() {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter both email and password"
            return
        }
        
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        loginUseCase.execute(email: email, password: password, role: selectedRole)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.onLoginSuccess(user)
            }
            .store(in: &cancellables)
    }
    
    func navigateToRegister() {
        router.navigate(.register)
    }
    
    func navigateToForgotPassword() {
        router.navigate(.forgotPassword)
    }
    
    func clearError() {
        errorMessage = nil
    }
}
