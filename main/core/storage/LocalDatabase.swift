//
//  LocalDatabase.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 14/08/26.
//

import Foundation

// MARK: - Local Database Protocol
protocol LocalDatabaseProtocol {
    func set<T: Encodable>(_ value: T, forKey key: String)
    func get<T: Decodable>(forKey key: String) -> T?
    func remove(forKey key: String)
}

// MARK: - Local Database Implementation
final class LocalDatabase: LocalDatabaseProtocol {
    static let shared = LocalDatabase()
    private let defaults = UserDefaults.standard
    
    private init() {
        print("🟢[ARC] LocalDatabase ALLOCATED")
    }
    
    deinit {
        print("🔴[ARC] LocalDatabase DEALLOCATED")
    }
    
    func set<T: Encodable>(_ value: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            defaults.set(encoded, forKey: key)
        }
    }
    
    func get<T: Decodable>(forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key),
              let value = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        return value
    }
    
    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}
