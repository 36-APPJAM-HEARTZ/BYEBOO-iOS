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
    func loginWithApple(completion: @escaping (String?, String?, (any Error)?) -> Void)
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
    
    func loginWithApple(completion: @escaping (String?, String?, (any Error)?) -> Void) {
        ByeBooLogger.debug("mock 객체가 호출되지 않고 있음")
        completion(nil, nil, nil)
    }
}

struct MockUserAPI: UserAPIManager {
    
    private let isAvailable: Bool
    private let oAuthToken = MockOAuthToken.kakaoStub()
    
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
    
    func loginWithApple(completion: @escaping (String?, String?, (any Error)?) -> Void) {
        completion("identityToken", "authorizationCode", nil)
    }
}
