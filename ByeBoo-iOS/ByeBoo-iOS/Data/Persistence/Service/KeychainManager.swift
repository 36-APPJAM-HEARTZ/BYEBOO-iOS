//
//  KeychainManager.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/27/25.
//

import Foundation
import Security

enum KeyType: String {
    case authorization
    case accessToken
    case refreshToken
}

enum KeychainManager {
    static func save(key: KeyType, token: String) {
        let data = token.data(using: .utf8, allowLossyConversion: false) as Any
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            ByeBooLogger.debug("키체인 \(key) 저장 성공")
            ByeBooLogger.debug("저장된 토큰: \(token)")
        } else {
            ByeBooLogger.debug("키체인 \(key) 저장 실패")
        }
    }
    
    static func load(key: KeyType) -> String {
        let query: [CFString: Any]  = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key.rawValue,
                kSecReturnData: kCFBooleanTrue as Any,
                kSecMatchLimit: kSecMatchLimitOne
            ]
            
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess {
            ByeBooLogger.debug("키체인 \(key) 로드 실패")
            return ""
        }
        
        guard let data = item as? Data,
              let token = String(data: data, encoding: .utf8) else {
            ByeBooLogger.debug("키체인 \(key) 디코딩 실패")
            return ""
        }

        ByeBooLogger.debug("키체인 \(key)의 값 \(token) 로드 성공")
        return token
    }
    
    static func delete(key: KeyType) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ]
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            ByeBooLogger.debug("키체인 \(key) 삭제 성공")
        } else {
            ByeBooLogger.debug("키체인 \(key) 삭제 실패")
        }
    }
}
