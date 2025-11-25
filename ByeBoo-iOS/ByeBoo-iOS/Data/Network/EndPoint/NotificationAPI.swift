//
//  NotificationAPI.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 11/22/25.
//

import Foundation

import Alamofire

enum NotificationAPI {
    case saveToken(dto: FCMTokenDTO)
    case updateToken(dto: FCMTokenDTO)
    case deleteToken(dto: FCMTokenDTO)
}

extension NotificationAPI: EndPoint {
    
    private static let keychainService = DefaultKeychainService()
    
    var basePath: String {
        return "/api/v1/notification-tokens"
    }
    
    var path: String {
        switch self {
        case .saveToken, .updateToken, .deleteToken:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .saveToken:
            return .post
        case .updateToken:
            return .patch
        case .deleteToken:
            return .put
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .saveToken, .updateToken, .deleteToken:
            let accessToken = NotificationAPI.keychainService.load(key: .accessToken)
            return .withAuth(acessToken: accessToken)
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .saveToken, .updateToken, .deleteToken:
            return JSONEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .saveToken, .updateToken, .deleteToken:
            return nil
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .saveToken(let dto), .updateToken(let dto), .deleteToken(let dto):
            return try? dto.toDictionary()
        }
    }
}
