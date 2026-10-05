//
//  ForgotPasswordView.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import SwiftUI

// MARK: - Forgot Password View
struct ForgotPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Image(systemName: "lock.rotation")
                    .font(.system(size: 54))
                    .foregroundColor(.accentColor)
                
                Text("Reset Password")
                    .font(.title2.weight(.bold))
                
                Text("Enter your email to receive recovery instructions")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            VStack(spacing: 16) {
                TextField("Email address", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                if viewModel.isSuccess {
                    Text("Password reset instructions sent!")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                
                Button(action: {
                    viewModel.submitResetRequest()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Send Reset Link")
                            .font(.headline)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .cornerRadius(12)
                .disabled(viewModel.isLoading)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .navigationTitle("Forgot Password")
        .navigationBarTitleDisplayMode(.inline)
    }
}
