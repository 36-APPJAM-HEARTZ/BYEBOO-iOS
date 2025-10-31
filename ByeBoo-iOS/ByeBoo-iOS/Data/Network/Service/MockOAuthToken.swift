//
//  OAuthTokenFactory.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 10/29/25.
//

import KakaoSDKAuth

struct MockOAuthToken {
    
    static func stub() -> OAuthToken {
        return .init(
            accessToken: "accessToken",
            tokenType: "tokenType",
            refreshToken: "refreshToken",
            scope: nil,
            scopes: nil
        )
    }
}
