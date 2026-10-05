//
//  LoginView.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import SwiftUI

// MARK: - Login View
struct LoginView: View {
    @ObservedObject var router: Router<AuthRoute>
    @StateObject private var viewModel: LoginViewModel
    
    // MARK: - Initialization
    init(
        router: Router<AuthRoute>,
        onLoginSuccess: @escaping (User) -> Void
    ) {
        self.router = router
        _viewModel = StateObject(
            wrappedValue: AuthAssembly.shared.makeLoginViewModel(
                router: router,
                onLoginSuccess: onLoginSuccess
            )
        )
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $router.navPaths) {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    roleQuickLoginSection
                    dividerSection
                    credentialsFormSection
                    footerSection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Sign In")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: AuthRoute.self) { route in
                route.destinationView
            }
        }
    }
    
    // MARK: - Subviews
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "app.badge.checkmark")
                .font(.system(size: 48))
                .foregroundColor(.blue)
            
            Text("ReadyMade Portal")
                .font(.title2.weight(.bold))
            
            Text("Select an MVP role to test dynamic tabs or sign in with your credentials")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .padding(.top, 10)
    }
    
    private var roleQuickLoginSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TEST MVP BY ROLE")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 10) {
                roleButton(
                    title: "Login as Student",
                    subtitle: "Home, Attendance, Internships, Profile (4 tabs)",
                    icon: "graduationcap.fill",
                    color: Color.blue,
                    role: .student
                )
                
                roleButton(
                    title: "Login as Mentor",
                    subtitle: "Home, Students, Profile (3 tabs)",
                    icon: "person.crop.circle.badge.checkmark",
                    color: Color.green,
                    role: .mentor
                )
                
                roleButton(
                    title: "Login as Organisation",
                    subtitle: "Home, Approvals, Students, Profile (4 tabs)",
                    icon: "building.2.crop.circle",
                    color: Color.orange,
                    role: .organisation
                )
                
                roleButton(
                    title: "Login as College",
                    subtitle: "Home, Approvals, Students, Profile (4 tabs)",
                    icon: "building.columns.circle",
                    color: Color.purple,
                    role: .college
                )
            }
        }
    }
    
    private func roleButton(
        title: String,
        subtitle: String,
        icon: String,
        color: Color,
        role: UserRole
    ) -> some View {
        Button(action: {
            viewModel.login(as: role)
        }) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(.tertiaryLabel))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isLoading)
    }
    
    private var dividerSection: some View {
        HStack {
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 1)
            
            Text("OR CREDENTIALS")
                .font(.caption2.weight(.bold))
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
            
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 1)
        }
        .padding(.vertical, 8)
    }
    
    private var credentialsFormSection: some View {
        VStack(spacing: 12) {
            Picker("Role", selection: $viewModel.selectedRole) {
                ForEach(UserRole.allCases) { role in
                    Text(role.title).tag(role)
                }
            }
            .pickerStyle(.segmented)
            
            TextField("Email address", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Button(action: {
                viewModel.loginWithCredentials()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign In")
                        .font(.headline)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.blue)
            .cornerRadius(12)
            .disabled(viewModel.isLoading)
        }
    }
    
    private var footerSection: some View {
        HStack {
            Button("Forgot Password?") {
                viewModel.navigateToForgotPassword()
            }
            .font(.footnote)
            .foregroundColor(.blue)
            
            Spacer()
            
            Button("Create Account") {
                viewModel.navigateToRegister()
            }
            .font(.footnote.weight(.semibold))
            .foregroundColor(.blue)
        }
        .padding(.top, 4)
    }
}
