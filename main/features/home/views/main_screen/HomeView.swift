//
//  HomeView.swift
//  ReadyMadeProjectSetup
//
//  Created by kundan Dev on 20/09/26.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var homeRouter   = Router<HomeNavRouter>()
    @StateObject private var viewModel    = HomeViewModel()
    
    var body: some View {
        NavigationStack(path: $homeRouter.navPaths) {
            mainContent
                .navigationTitle("Posts")
                .navigationBarTitleDisplayMode(.large)
                .navigationDestination(for: HomeNavRouter.self) { destination in
                    destination.destinationView
                }
                .task {
                    // Using async/await — recommended way
                    viewModel.fetchAllPostsWithAsyncAwait()
                }
        }
    }
}

// MARK: - Sub Views
extension HomeView {
    
    @ViewBuilder
    private var mainContent: some View {
        switch viewModel.apiState {
        case .idle:
            EmptyView()
            
        case .loading:
            ProgressView("Loading posts…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .dataloaded:
            postsList
            
        case .failures(let message):
            ContentUnavailableView(
                "Something went wrong",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }
    
    private var postsList: some View {
        List(viewModel.posts, id: \.id) { post in
            Button {
                homeRouter.navPaths.append(HomeNavRouter.home_detail(post))
            } label: {
                PostRowView(post: post)
            }
            .buttonStyle(.plain)
        }
        .listStyle(.plain)
    }
}

#Preview {
    HomeView()
}
