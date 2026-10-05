//
//  MainView.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import SwiftUI

// MARK: - Root Main View
struct MainView: View {
    @StateObject private var sessionManager = AppSessionManager.shared
    @StateObject private var authRouter = Router<AuthRoute>()
    
    var body: some View {
        Group {
            if let user = sessionManager.currentUser {
                MainTabBarView(
                    user: user,
                    onLogout: {
                        withAnimation {
                            sessionManager.logout()
                            authRouter.navigateToRoot()
                        }
                    }
                )
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.98)),
                    removal: .opacity
                ))
            } else {
                LoginView(
                    router: authRouter,
                    onLoginSuccess: { user in
                        withAnimation {
                            sessionManager.login(user: user)
                        }
                    }
                )
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    MainView()
}
