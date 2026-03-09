//
//  UsersAPI.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

import Foundation

import Alamofire

enum UsersAPI {
    case journey
    case sendUser(requestDTO: UserRequestDTO)
    case character
    case count
    case start
    case modifyName(requestDTO: UserNameRequestDTO)
    case updateNotificationPermission
    case fetchCommonQuestAnswers(cursor: Int?)
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
        case .fetchCommonQuestAnswers(cursor: let cursor):
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
        case .journey,.sendUser, .character, .count,
                .start,.modifyName,.updateNotificationPermission,
                .fetchCommonQuestAnswers:
            return .withAuth
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
        case .fetchCommonQuestAnswers(let cursor):
            return cursor.map { ["cursor": "\($0)"] }
        default:
            return nil
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .journey, .character, .count, .start, .updateNotificationPermission, .fetchCommonQuestAnswers:
            return nil
        case .sendUser(let dto):
            return try? dto.toDictionary()
        case .modifyName(let dto):
            return try? dto.toDictionary()
        }
    }
}

