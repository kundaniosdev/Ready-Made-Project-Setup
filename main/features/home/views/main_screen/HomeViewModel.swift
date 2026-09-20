//
//  HomeViewModel.swift
//  ReadyMadeProjectSetup
//
//  Created by kundan Dev on 20/09/26.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {

    // MARK: - Published State
    @Published var posts:    [Post]    = []

    enum APIStates: Equatable {
        case idle
        case loading
        case dataloaded
        case failures(String)
    }

    @Published var apiState: APIStates = .idle

    // MARK: - Injected Dependencies (via HomeDI)
    private let asyncClient:    APIClient
    private let callbackClient: APIClientCompletionHandler

    // MARK: - Lifecycle
    init(asyncClient: APIClient? = nil,
         callbackClient: APIClientCompletionHandler? = nil) {
        self.asyncClient    = asyncClient ?? APIClient()
        self.callbackClient = callbackClient ?? APIClientCompletionHandler()
        print("🟢 [ARC] HomeViewModel ALLOCATED")
    }

    deinit {
        print("🔴 [ARC] HomeViewModel DEALLOCATED")
    }

    // MARK: - Way 1: Completion Handler
    func fetchAllPostsWithCompletionHandler() {
        self.apiState = .loading
        callbackClient.fetchPost { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let data):
                    self.posts    = data
                    self.apiState = .dataloaded
                case .failure(let error):
                    self.apiState = .failures(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Way 2: async / await  ← Recommended
    func fetchAllPostsWithAsyncAwait() {
        Task {
            self.apiState = .loading
            do {
                let data      = try await asyncClient.fetchPosts()
                self.posts    = data
                self.apiState = .dataloaded
            } catch {
                self.apiState = .failures(error.localizedDescription)
            }
        }
    }
}
