//
//  HomeDetailViewModel.swift
//  ReadyMadeProjectSetup
//
//  Created by kundan Dev on 20/09/26.
//

import Foundation
import Combine

@MainActor
class HomeDetailViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var post: Post
    
    // MARK: - Lifecycle
    init(post: Post) {
        self.post = post
        print("🟢 [ARC] HomeDetailViewModel ALLOCATED — Post id: \(post.id ?? -1)")
    }
    
    deinit {
        print("🔴 [ARC] HomeDetailViewModel DEALLOCATED")
    }
}
