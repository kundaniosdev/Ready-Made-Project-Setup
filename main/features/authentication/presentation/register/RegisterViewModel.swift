//
//  RegisterViewModel.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import Combine

// MARK: - Register View Model
final class RegisterViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var selectedRole: UserRole = .student
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private let registerUseCase: RegisterUserUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(registerUseCase: RegisterUserUseCase = AuthAssembly.shared.makeRegisterUseCase()) {
        self.registerUseCase = registerUseCase
        print("🟢[ARC] RegisterViewModel ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] RegisterViewModel DEALLOCATED")
    }
    
    // MARK: - Public Methods
    func register(onSuccess: @escaping (User) -> Void) {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        registerUseCase.execute(name: name, email: email, password: password, role: selectedRole)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { user in
                onSuccess(user)
            }
            .store(in: &cancellables)
    }
}
