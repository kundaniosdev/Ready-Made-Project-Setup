//
//  ResetPasswordUseCase.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import Combine

// MARK: - Reset Password Use Case Protocol
protocol ResetPasswordUseCase {
    func execute(email: String) -> AnyPublisher<Bool, Error>
}

// MARK: - Reset Password Use Case Implementation
final class ResetPasswordUseCaseImpl: ResetPasswordUseCase {
    init() {
        print("🟢[ARC] ResetPasswordUseCaseImpl ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] ResetPasswordUseCaseImpl DEALLOCATED")
    }
    
    func execute(email: String) -> AnyPublisher<Bool, Error> {
        return Just(true)
            .setFailureType(to: Error.self)
            .delay(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
