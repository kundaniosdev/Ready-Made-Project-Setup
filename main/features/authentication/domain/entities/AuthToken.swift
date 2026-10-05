//
//  AuthToken.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation

// MARK: - Auth Token Entity
struct AuthToken: Codable, Equatable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: TimeInterval
    
    init(
        accessToken: String = UUID().uuidString,
        refreshToken: String = UUID().uuidString,
        expiresIn: TimeInterval = 3600
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
    }
}
