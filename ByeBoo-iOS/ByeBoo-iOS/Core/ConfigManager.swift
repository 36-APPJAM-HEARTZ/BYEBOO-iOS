//
//  ConfigManager.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 11/24/25.
//

import Foundation

enum ConfigKey: String {
    case baseURL = "BASE_URL"
    case kakaoNativeAppKey = "KAKAO_NATIVE_APP_KEY"
    case mixpanelToken = "MIXPANEL_TOKEN"
    case appID = "APP_ID"
}

struct ConfigManager {
    private static func toString(for key: ConfigKey) -> String {
        guard let value = Bundle.main.infoDictionary?[key.rawValue] as? String
        else {
            ByeBooLogger.error(ByeBooError.configError)
            return ""
        }
        return value
    }
    
    static var baseURL: String { toString(for: .baseURL) }
    static var kakaoNativeAppKey: String { toString(for: .kakaoNativeAppKey) }
    static var mixpanelToken: String { toString(for: .mixpanelToken) }
    static var appID: String { toString(for: .appID) }
}
