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
    case fetchCommonQuestAnswers(accessToken: String, cursor: Int?)
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
        case .fetchCommonQuestAnswers(accessToken: let accessToken, cursor: let cursor):
            return "/me/common-quests"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .journey, .character, .count, .fetchCommonQuestAnswers:
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
                .updateNotificationPermission(let accessToken),
                .fetchCommonQuestAnswers(let accessToken, _):
            return .withAuth(acessToken: accessToken)
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .journey, .character, .count, .start, .fetchCommonQuestAnswers:
            return URLEncoding.default
        case .sendUser, .modifyName, .updateNotificationPermission:
            return JSONEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchCommonQuestAnswers(_, let cursor):
            return cursor.map { ["cursor": "\($0)"] }
        default:
            return nil
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .journey, .character, .count, .start, .updateNotificationPermission, .fetchCommonQuestAnswers:
            return nil
        case .sendUser(_, let dto):
            return try? dto.toDictionary()
        case .modifyName(_, let dto):
            return try? dto.toDictionary()
        }
    }
}

