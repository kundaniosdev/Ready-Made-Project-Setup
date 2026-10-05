//
//  OTPVerificationView.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import SwiftUI

// MARK: - OTP Verification View
struct OTPVerificationView: View {
    let email: String
    @StateObject private var viewModel = OTPVerificationViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Image(systemName: "envelope.badge.shield.half.filled")
                    .font(.system(size: 54))
                    .foregroundColor(.blue)
                
                Text("Verification Code")
                    .font(.title2.weight(.bold))
                
                Text("Enter the OTP code sent to\n\(email)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            VStack(spacing: 16) {
                TextField("Enter 6-digit code", text: $viewModel.otpCode)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.title3.monospaced())
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                if viewModel.isVerified {
                    Text("Successfully verified!")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                
                Button(action: {
                    viewModel.verify(email: email)
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Verify Code")
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
        .navigationTitle("OTP Verification")
        .navigationBarTitleDisplayMode(.inline)
    }
}
