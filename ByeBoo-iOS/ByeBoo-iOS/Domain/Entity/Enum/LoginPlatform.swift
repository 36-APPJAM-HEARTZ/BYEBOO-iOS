//
//  LoginPlatform.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/27/25.
//

enum LoginPlatform: String {
    case KAKAO
    case APPLE
}

extension LoginPlatform {
    var mixpanelKey: String {
        switch self {
        case .KAKAO:
            "Kakao"
        case .APPLE:
            "Apple"
        }
    }
}
