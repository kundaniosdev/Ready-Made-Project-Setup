//
//  UserDTO.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation

// MARK: - User DTO
struct UserDTO: Codable {
    let id: String
    let name: String
    let email: String
    let role: String
    let avatarUrl: String?
    
    // MARK: - Mapping
    func toDomain() -> User {
        let userRole = UserRole(rawValue: role) ?? .student
        return User(
            id: id,
            name: name,
            email: email,
            role: userRole,
            avatarUrl: avatarUrl
        )
    }
}
