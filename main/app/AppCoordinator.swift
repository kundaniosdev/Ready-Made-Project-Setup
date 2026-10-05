//
//  AppCoordinator.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import SwiftUI
import Combine

//  MARK: - BASE INFRASTRUCTURE
//  Provides the core generic Router<T> engine and NavigationDestination protocol
//  used by all feature-specific routers in the app for type-safe SwiftUI navigation.

protocol NavigationDestination: Hashable {
    associatedtype Destination: View
    var title: String { get }
    
    @ViewBuilder
    var destinationView: Destination { get }
}

final class Router<Destination: NavigationDestination>: ObservableObject {
    @Published var navPaths: [Destination] = []
    
    init() {
        print("🟢[ARC] Router<\(Destination.self)> ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] Router<\(Destination.self)> DEALLOCATED")
    }
    
    func navigate(_ destination: Destination) {
        navPaths.append(destination)
    }
    
    func navigateBack() {
        guard !navPaths.isEmpty else { return }
        navPaths.removeLast()
    }
    
    func navigateToRoot() {
        navPaths.removeAll()
    }
}

// MARK: - App Session State
final class AppSessionManager: ObservableObject {
    static let shared = AppSessionManager()
    
    @Published var currentUser: User?
    
    init() {
        print("🟢[ARC] AppSessionManager ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] AppSessionManager DEALLOCATED")
    }
    
    func login(user: User) {
        currentUser = user
    }
    
    func logout() {
        currentUser = nil
    }
}
