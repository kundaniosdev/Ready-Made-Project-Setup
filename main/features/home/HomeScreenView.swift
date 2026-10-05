//
//  HomeScreenView.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import SwiftUI

// MARK: - Home Screen View
struct HomeScreenView: View {
    @StateObject private var viewModel = HomeScreenViewModel()
    let currentUser: User?
    
    init(currentUser: User? = nil) {
        self.currentUser = currentUser
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    userHeaderCard
                    statsSection
                    quickActionsSection
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Home")
            .onAppear {
                viewModel.configure(for: currentUser)
            }
        }
    }
    
    // MARK: - Subviews
    private var userHeaderCard: some View {
        HStack(spacing: 16) {
            Image(systemName: currentUser?.role.iconName ?? "person.circle.fill")
                .font(.system(size: 38))
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(currentUser?.name ?? "Welcome Guest")
                    .font(.title3.weight(.bold))
                
                HStack(spacing: 6) {
                    Text(currentUser?.role.title ?? "Role")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.orange.opacity(0.15))
                        .foregroundColor(.orange)
                        .cornerRadius(6)
                    
                    Text(currentUser?.email ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(14)
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("OVERVIEW")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                statCard(title: "Active Status", value: "Active", icon: "bolt.fill", color: .green)
                statCard(title: "Role Level", value: currentUser?.role.title ?? "-", icon: "shield.fill", color: .blue)
                statCard(title: "Tasks Pending", value: "3", icon: "checklist", color: .orange)
                statCard(title: "Notifications", value: "5 New", icon: "bell.fill", color: .purple)
            }
        }
    }
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ROLE INSIGHT")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Logged in as \(currentUser?.role.title ?? "User")")
                    .font(.subheadline.weight(.semibold))
                Text("Your navigation tab bar is dynamically configured for the \(currentUser?.role.title ?? "selected") role. Check the tabs at the bottom to explore role-specific screens.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }
}
