//
//  AppleLoginManager.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 10/31/25.
//

import Foundation

protocol AppleLoginProtocol {
    func loginWithApple(completion: @escaping (String?, String?, (any Error)?) -> Void)
}

struct AppleLoginManager: AppleLoginProtocol {
    func loginWithApple(completion: @escaping (String?, String?, (any Error)?) -> Void) {
        ByeBooLogger.debug("mock 객체가 호출되지 않고 있음")
        completion(nil, nil, nil)
    }
}

struct MockAppleLoginManager: AppleLoginProtocol {
    func loginWithApple(completion: @escaping (String?, String?, (any Error)?) -> Void) {
        completion("identityToken", "authorizationCode", nil)
    }
}
