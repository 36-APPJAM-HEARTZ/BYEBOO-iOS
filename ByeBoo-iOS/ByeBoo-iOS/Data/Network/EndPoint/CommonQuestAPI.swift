//
//  CommonQuestAPI.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/1/26.
//

import Foundation

import Alamofire

enum CommonQuestAPI {
    case postCommonQuest(accessToken: String, questID: Int, dto: SaveCommonQuestRequestDTO)
    case fetchCommonQuest(accessToken: String, date: String, cursor: Int?)
    case updateCommonQuest(accessToken: String, answerID: Int, dto: UpdateCommonQuestRequestDTO)
}

extension CommonQuestAPI: EndPoint {
    
    var basePath: String {
        return "/api/v1/common-quests"
    }
    
    var path: String {
        switch self {
        case .postCommonQuest(_, let questID, _):
            return "/\(questID)"
        case .fetchCommonQuest:
            return ""
        case .updateCommonQuest(_ , let answerID, _):
            return "/\(answerID)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postCommonQuest:
            return .post
        case .fetchCommonQuest:
            return .get
        case .updateCommonQuest:
            return .patch
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .postCommonQuest(let accessToken, _, _),
                .fetchCommonQuest(let accessToken, _, _),
                .updateCommonQuest(let accessToken, _, _):
            return .withAuth(acessToken: accessToken)
        }
    }
    
    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .postCommonQuest, .updateCommonQuest:
            return JSONEncoding.default
        case .fetchCommonQuest:
            return  URLEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .postCommonQuest, .updateCommonQuest:
            return nil
        case .fetchCommonQuest(_, let date, let cursor):
            if let cursor {
                return [
                    "date": date,
                    "cursor": "\(cursor)"
                ]
            }
            return ["date": date]
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .postCommonQuest(_, _, let dto):
            return try? dto.toDictionary()
        case .fetchCommonQuest:
            return nil
        case .updateCommonQuest(_, _, let dto):
            return try? dto.toDictionary()
        }
    }
}
