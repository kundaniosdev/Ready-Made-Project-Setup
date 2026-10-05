//
//  KeychainManager.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation

// MARK: - Keychain Manager Protocol
protocol KeychainManagerProtocol {
    func save(key: String, data: Data) -> Bool
    func load(key: String) -> Data?
    func delete(key: String) -> Bool
}

// MARK: - Keychain Manager Implementation
final class KeychainManager: KeychainManagerProtocol {
    static let shared = KeychainManager()
    
    private init() {
        print("🟢[ARC] KeychainManager ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] KeychainManager DEALLOCATED")
    }
    
    func save(key: String, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    func load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess {
            return dataTypeRef as? Data
        }
        return nil
    }
    
    func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
