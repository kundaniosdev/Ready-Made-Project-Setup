//
//  HomeContainer.swift
//  ReadyMadeProjectSetup
//
//  Created by kundan Dev on 20/09/26.
//

import Foundation
//
//  HomeViewModelDI.swift
//  ReadyMadeProjectSetup
//
//  Created by kundan Dev on 20/09/26.
//

/*
 ┌──────────────────────────────────────────────────────────────┐
 │              Dependency Injection  —  Home Feature           │
 │                                                              │
 │  This file is the single place to create & wire up          │
 │  ViewModels for the Home feature.                            │
 │                                                              │
 │  Pattern:  Factory function / DI container                   │
 │  Benefit:  Views never create their own dependencies.        │
 │            Swap real ↔ mock clients without touching views.  │
 └──────────────────────────────────────────────────────────────┘
 */

import Foundation

// MARK: - Home DI Container
enum HomeContainer {

    // ─────────────────────────────────────────────────────────
    // MARK: HomeViewModel  (async/await path — recommended)
    // ─────────────────────────────────────────────────────────
    /// Creates a HomeViewModel wired to the real async APIClient.
    /// Swap `APIClient()` for a mock here during unit tests.
    @MainActor
    static func makeHomeViewModel() -> HomeViewModel {
        // Real network client injected here
        let apiClient = APIClient()
        return HomeViewModel(asyncClient: apiClient)
    }

    // ─────────────────────────────────────────────────────────
    // MARK: HomeDetailViewModel
    // ─────────────────────────────────────────────────────────
    /// Creates a HomeDetailViewModel for a given Post.
    @MainActor
    static func makeDetailViewModel(post: Post) -> HomeDetailViewModel {
        HomeDetailViewModel(post: post)
    }
}
