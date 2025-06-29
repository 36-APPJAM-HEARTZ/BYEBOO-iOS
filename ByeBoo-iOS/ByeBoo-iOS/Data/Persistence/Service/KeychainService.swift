//
//  KeychainService.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import Foundation

protocol KeychainService {
    func save()
    func load()
    func delete()
}

struct DefaultKeychainService: KeychainService {
    func save() {
        //keychain에 저장
    }
    
    func load() {
        //
    }
    
    func delete() {
        //
    }
}
