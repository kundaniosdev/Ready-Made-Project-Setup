//
//  AuthRoute.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import SwiftUI

// MARK: - Auth Route Destination
enum AuthRoute: NavigationDestination, Hashable {
    case forgotPassword
    case register
    case otpVerification(email: String)
    
    // MARK: - Title
    var title: String {
        switch self {
        case .forgotPassword:
            return "Forgot Password"
        case .register:
            return "Register"
        case .otpVerification:
            return "Verify OTP"
        }
    }
    
    // MARK: - Destination View
    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .forgotPassword:
            ForgotPasswordView()
        case .register:
            RegisterView()
        case .otpVerification(let email):
            OTPVerificationView(email: email)
        }
    }
    
    // MARK: - Hashable Conformance
    func hash(into hasher: inout Hasher) {
        switch self {
        case .forgotPassword:
            hasher.combine(0)
        case .register:
            hasher.combine(1)
        case .otpVerification(let email):
            hasher.combine(2)
            hasher.combine(email)
        }
    }
    
    // MARK: - Equatable Conformance
    static func == (lhs: AuthRoute, rhs: AuthRoute) -> Bool {
        switch (lhs, rhs) {
        case (.forgotPassword, .forgotPassword),
             (.register, .register):
            return true
        case (.otpVerification(let lhsEmail), .otpVerification(let rhsEmail)):
            return lhsEmail == rhsEmail
        default:
            return false
        }
    }
}
