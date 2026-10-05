//
//  ForgotPasswordViewModel.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import Combine

// MARK: - Forgot Password View Model
final class ForgotPasswordViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private let resetPasswordUseCase: ResetPasswordUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(resetPasswordUseCase: ResetPasswordUseCase = AuthAssembly.shared.makeResetPasswordUseCase()) {
        self.resetPasswordUseCase = resetPasswordUseCase
        print("🟢[ARC] ForgotPasswordViewModel ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] ForgotPasswordViewModel DEALLOCATED")
    }
    
    // MARK: - Public Methods
    func submitResetRequest() {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your email"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        resetPasswordUseCase.execute(email: email)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] success in
                self?.isSuccess = success
            }
            .store(in: &cancellables)
    }
}
