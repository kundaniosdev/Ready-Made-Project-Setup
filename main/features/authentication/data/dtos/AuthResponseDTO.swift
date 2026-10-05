//
//  AuthResponseDTO.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation

// MARK: - Auth Response DTO
struct AuthResponseDTO: Codable {
    let user: UserDTO
    let token: String
    let refreshToken: String?
    
    // MARK: - Mapping
    func toDomain() -> (user: User, token: AuthToken) {
        let domainUser = user.toDomain()
        let authToken = AuthToken(
            accessToken: token,
            refreshToken: refreshToken ?? UUID().uuidString
        )
        return (domainUser, authToken)
    }
}
