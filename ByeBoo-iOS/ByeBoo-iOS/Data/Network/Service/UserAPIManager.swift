//
//  MockUserAPI.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 10/29/25.
//

import Foundation

import KakaoSDKAuth
import KakaoSDKUser

protocol UserAPIManager {
    func isKakaoTalkLoginAvailable() -> Bool
    func loginWithKakaoTalk(completion: @escaping (OAuthToken?, (any Error)?) -> Void)
    func loginWithKakaoAccount(completion: @escaping (OAuthToken?, (any Error)?) -> Void)
}

struct UserAPI: UserAPIManager {
    func isKakaoTalkLoginAvailable() -> Bool {
        UserApi.isKakaoTalkLoginAvailable()
    }
    
    func loginWithKakaoTalk(completion: @escaping (OAuthToken?, (any Error)?) -> Void) {
        UserApi.shared.loginWithKakaoTalk(completion: completion)
    }
    
    func loginWithKakaoAccount(completion: @escaping (OAuthToken?, (any Error)?) -> Void) {
        UserApi.shared.loginWithKakaoTalk(completion: completion)
    }
}

struct MockUserAPI: UserAPIManager {
    
    private let isAvailable: Bool
    private let oAuthToken = OAuthTokenFactory.makeOAuthToken()
    
    init(isAvailable: Bool) {
        self.isAvailable = isAvailable
    }
    
    func isKakaoTalkLoginAvailable() -> Bool {
        return isAvailable
    }
    
    func loginWithKakaoTalk(completion: @escaping (OAuthToken?, (any Error)?) -> Void) {
        completion(oAuthToken, nil)
    }
    
    func loginWithKakaoAccount(completion: @escaping (OAuthToken?, (any Error)?) -> Void) {
        completion(oAuthToken, nil)
    }
}
