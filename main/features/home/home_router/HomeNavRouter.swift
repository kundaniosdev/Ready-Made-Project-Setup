//
//  HomeNavRouter.swift
//  ReadyMadeProjectSetup
//
//  Created by kundan Dev on 20/09/26.
//

import Foundation
import SwiftUI

enum HomeNavRouter: NavigationDestination, Hashable {
    
    case home_screen
    case home_detail(Post)
    
    // MARK: - Hashable (manual — needed because of @ViewBuilder property)
    func hash(into hasher: inout Hasher) {
        switch self {
        case .home_screen:
            hasher.combine(0)
        case .home_detail(let post):
            hasher.combine(1)
            hasher.combine(post.id)
        }
    }
    
    static func == (lhs: HomeNavRouter, rhs: HomeNavRouter) -> Bool {
        switch (lhs, rhs) {
        case (.home_screen, .home_screen):
            return true
        case (.home_detail(let a), .home_detail(let b)):
            return a.id == b.id
        default:
            return false
        }
    }
    
    // MARK: - NavigationDestination
    var title: String {
        switch self {
        case .home_screen:  return "Home"
        case .home_detail:  return "Post Detail"
        }
    }
    
    var destinationView: some View {
        switch self {
        case .home_screen:
            HomeView()
        case .home_detail(let post):
            HomeDetailView(post: post)
        }
    }
}
