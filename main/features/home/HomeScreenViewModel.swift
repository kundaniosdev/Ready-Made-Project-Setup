//
//  HomeScreenViewModel.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Home Screen View Model
final class HomeScreenViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var welcomeMessage: String = "Welcome to ReadyMade Setup"
    @Published var isLoading: Bool = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        print("🟢[ARC] HomeScreenViewModel ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] HomeScreenViewModel DEALLOCATED")
    }
    
    // MARK: - Public Methods
    func configure(for user: User?) {
        guard let user = user else {
            welcomeMessage = "Welcome!"
            return
        }
        welcomeMessage = "Welcome, \(user.name) (\(user.role.title))"
    }
}
