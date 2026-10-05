//
//  User.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation

// MARK: - User Role
enum UserRole: String, Codable, CaseIterable, Identifiable {
    case student = "Student"
    case mentor = "Mentor"
    case organisation = "Organisation"
    case college = "College"
    
    var id: String { rawValue }
    
    var title: String {
        return rawValue
    }
    
    var iconName: String {
        switch self {
        case .student:
            return "graduationcap.fill"
        case .mentor:
            return "person.crop.circle.badge.checkmark"
        case .organisation:
            return "building.2.crop.circle"
        case .college:
            return "building.columns.circle"
        }
    }
}

// MARK: - User Entity
struct User: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let email: String
    let role: UserRole
    let avatarUrl: String?
    
    init(
        id: String = UUID().uuidString,
        name: String,
        email: String,
        role: UserRole,
        avatarUrl: String? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
        self.avatarUrl = avatarUrl
    }
}
