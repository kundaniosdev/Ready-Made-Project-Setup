//
//  OTPVerificationViewModel.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import Combine

// MARK: - OTP Verification View Model
final class OTPVerificationViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var otpCode: String = ""
    @Published var isLoading: Bool = false
    @Published var isVerified: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private let verifyOTPUseCase: VerifyOTPUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(verifyOTPUseCase: VerifyOTPUseCase = AuthAssembly.shared.makeVerifyOTPUseCase()) {
        self.verifyOTPUseCase = verifyOTPUseCase
        print("🟢[ARC] OTPVerificationViewModel ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] OTPVerificationViewModel DEALLOCATED")
    }
    
    // MARK: - Public Methods
    func verify(email: String) {
        guard otpCode.count >= 4 else {
            errorMessage = "Please enter a valid OTP"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        verifyOTPUseCase.execute(email: email, otp: otpCode)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] verified in
                self?.isVerified = verified
            }
            .store(in: &cancellables)
    }
}
