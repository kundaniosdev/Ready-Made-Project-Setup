//
//  VerifyOTPUseCase.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import Combine

// MARK: - Verify OTP Use Case Protocol
protocol VerifyOTPUseCase {
    func execute(email: String, otp: String) -> AnyPublisher<Bool, Error>
}

// MARK: - Verify OTP Use Case Implementation
final class VerifyOTPUseCaseImpl: VerifyOTPUseCase {
    init() {
        print("🟢[ARC] VerifyOTPUseCaseImpl ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] VerifyOTPUseCaseImpl DEALLOCATED")
    }
    
    func execute(email: String, otp: String) -> AnyPublisher<Bool, Error> {
        return Just(true)
            .setFailureType(to: Error.self)
            .delay(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
