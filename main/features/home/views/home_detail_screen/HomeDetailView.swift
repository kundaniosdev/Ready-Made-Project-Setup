//
//  HomeDetailView.swift
//  ReadyMadeProjectSetup
//
//  Created by kundan Dev on 20/09/26.
//

import SwiftUI

struct HomeDetailView: View {
    
    @StateObject private var viewModel: HomeDetailViewModel
    
    init(post: Post) {
        _viewModel = StateObject(wrappedValue: HomeDetailViewModel(post: post))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Post ID
                Text("Post #\(viewModel.post.id ?? 0)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Title
                Text(viewModel.post.title ?? "No Title")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                // Body
                Text(viewModel.post.body ?? "No content available.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                // User ID
                Label("User ID: \(viewModel.post.userId ?? 0)", systemImage: "person.circle")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .navigationTitle("Post Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HomeDetailView(post: Post(
            userId: 1,
            id: 1,
            title: "Sample Post Title Goes Here",
            body: "This is the full body text of the post. It can be quite long and will scroll."
        ))
    }
}
