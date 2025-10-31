//
//  AppleToken.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 10/31/25.
//

struct AppleToken {
    let identityToken: String
    let authorizationCode: String
}

extension AppleToken {
    static func stub() -> AppleToken {
        .init(
            identityToken: "identityToken",
            authorizationCode: "authorizationCode"
        )
    }
}
