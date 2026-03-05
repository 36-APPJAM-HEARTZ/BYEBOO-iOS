//
//  UsersAPI.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

import Foundation

import Alamofire

enum UsersAPI {
    case journey(accessToken: String)
    case sendUser(accessToken: String, requestDTO: UserRequestDTO)
    case character(accessToken: String)
    case count(accessToken: String)
    case start(accessToken: String)
    case modifyName(accessToken: String, requestDTO: UserNameRequestDTO)
    case updateNotificationPermission(accessToken: String)
}

extension UsersAPI: EndPoint {
    var basePath: String {
        return "/api/v1/users"

//        switch self {
//        case .journey, .character, .count, .start, .modifyName, .updateNotificationPermission:
//        case .sendUser:
//            return "/api/v2/users"
//        }
    }
    
    var path: String {
        switch self {
        case .journey:
            return "/journey"
        case .sendUser:
            return ""
        case .character:
            return "/character"
        case .count:
            return "/count"
        case .start:
            return "/journey/start"
        case .modifyName:
            return "/name"
        case .updateNotificationPermission:
            return "/alarm"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .journey, .character, .count:
            return .get
        case .sendUser, .start, .modifyName, .updateNotificationPermission:
            return .patch
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .journey(let accessToken),
                .sendUser(let accessToken, _),
                .character(let accessToken),
                .count(let accessToken),
                .start(let accessToken),
                .modifyName(let accessToken, _),
                .updateNotificationPermission(let accessToken):
            return .withAuth(acessToken: accessToken)
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .journey, .character, .count, .start:
            return URLEncoding.default
        case .sendUser, .modifyName, .updateNotificationPermission:
            return JSONEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        nil
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .journey, .character, .count, .start, .updateNotificationPermission:
            return nil
        case .sendUser(_, let dto):
            return try? dto.toDictionary()
        case .modifyName(_, let dto):
            return try? dto.toDictionary()
        }
    }
}

