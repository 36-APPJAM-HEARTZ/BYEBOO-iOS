//
//  KeychainService.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import Foundation

protocol KeychainService {
    func save(key: KeyType, token: String)
    func load(key: KeyType) -> String
    func delete(key: KeyType)
}

struct DefaultKeychainService: KeychainService {
    func save(key: KeyType, token: String) {
        KeychainManager.save(key: key, token: token)
    }
    
    func load(key: KeyType) -> String {
        KeychainManager.load(key: key)
    }
    
    func delete(key: KeyType) {
        KeychainManager.delete(key: key)
    }
}

final class MockKeychainService: KeychainService {
    
    private var store: [KeyType: Any] = [:]
    
    func save(key: KeyType, token: String) {
        store[key] = token
    }
    
    func load(key: KeyType) -> String {
        guard let value = store[key] as? String else {
            return ""
        }
        return value
    }
    
    func delete(key: KeyType) {
        store.removeValue(forKey: key)
    }
    
    func deleteAll() {
        store.removeAll()
    }
}
