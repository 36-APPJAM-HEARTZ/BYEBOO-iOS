//
//  OAuthTokenFactory.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 10/29/25.
//

import KakaoSDKAuth

struct MockOAuthToken {
    
    static func kakaoStub() -> OAuthToken {
        return .init(
            accessToken: "accessToken",
            tokenType: "tokenType",
            refreshToken: "refreshToken",
            scope: nil,
            scopes: nil
        )
    }
    
    static func appleStub() -> (String, String) {
        return ("identityToken", "authorizationCode")
    }
}
