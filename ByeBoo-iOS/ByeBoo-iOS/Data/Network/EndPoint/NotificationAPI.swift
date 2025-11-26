//
//  NotificationAPI.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 11/22/25.
//

import Foundation

import Alamofire

enum NotificationAPI {
    case saveToken(accessToken: String, dto: FCMTokenDTO)
    case updateToken(accessToken: String, dto: FCMTokenDTO)
    case deleteToken(accessToken: String, dto: FCMTokenDTO)
}

extension NotificationAPI: EndPoint {
        
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
        case .saveToken(let accessToken, _), .updateToken(let accessToken, _), .deleteToken(let accessToken, _):
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
        case .saveToken(_, let dto), .updateToken(_, let dto), .deleteToken(_, let dto):
            return try? dto.toDictionary()
        }
    }
}
