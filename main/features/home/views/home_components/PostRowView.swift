//
//  PostRowView.swift
//  ReadyMadeProjectSetup
//
//  Created by kundan Dev on 20/09/26.
//

import SwiftUI

struct PostRowView: View {
    
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            // Post ID badge
            Text("# \(post.id ?? 0)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            // Title
            Text(post.title ?? "No Title")
                .font(.headline)
                .lineLimit(2)
            
            // Body preview
            Text(post.body ?? "")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    PostRowView(post: Post(userId: 1, id: 1, title: "Sample Post Title Here", body: "This is the body of the post"))
        .padding()
}
