//
//  MockEnvronobjectServices.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 12/05/26.
//

import Foundation

// MARK: - Mock Environment Services
final class MockEnvironmentServices {
    static let shared = MockEnvironmentServices()

    private init() {
        print("🟢[ARC] MockEnvironmentServices ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] MockEnvironmentServices DEALLOCATED")
    }
}
