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
