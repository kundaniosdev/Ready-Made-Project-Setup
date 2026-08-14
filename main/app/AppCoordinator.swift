//
//  AppCoordinator.swift
//  PaginationInSwiftUI
//
//  Created by ibarts on 14/08/26.
//

import Foundation
import SwiftUI
        
//  MARK: - BASE INFRASTRUCTURE
//  Provides the core generic Router<T> engine and NavigationDestination protocol
//  used by all feature-specific routers in the app for type-safe SwiftUI navigation.

protocol NavigationDestination {
    associatedtype Destination:View
    var title:String { get }
    
    @ViewBuilder
    var destinationView:Destination { get }
}

class Router<Destination:NavigationDestination>: ObservableObject {
    @Published var navPaths:[Destination] = []
    
    func navigate(_ destination:Destination) {
        navPaths.append(destination)
    }
    
    func navigateBack() {
        guard !navPaths.isEmpty else { return }
        navPaths.removeLast()
    }
    
    func navigateToRoot() {
        navPaths.removeLast(navPaths.count)
    }
    
}
