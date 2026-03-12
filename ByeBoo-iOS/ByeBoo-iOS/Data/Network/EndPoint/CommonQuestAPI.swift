//
//  CommonQuestAPI.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/1/26.
//

import Foundation

import Alamofire

enum CommonQuestAPI {
    case postCommonQuest(questID: Int, dto: SaveCommonQuestRequestDTO)
    case fetchCommonQuest(date: String, cursor: Int?)
    case updateCommonQuest(answerID: Int, dto: UpdateCommonQuestRequestDTO)
    case deleteCommonQuest(answerID: Int)
}

extension CommonQuestAPI: EndPoint {
    
    var basePath: String {
        return "/api/v1/common-quests"
    }
    
    var path: String {
        switch self {
        case .postCommonQuest(let questID, _):
            return "/\(questID)"
        case .fetchCommonQuest:
            return ""
        case .updateCommonQuest(let answerID, _), .deleteCommonQuest(let answerID):
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
        case .deleteCommonQuest:
            return .delete
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .postCommonQuest, .fetchCommonQuest, .updateCommonQuest, .deleteCommonQuest:
            return .withAuth
        }
    }
    
    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .postCommonQuest, .updateCommonQuest:
            return JSONEncoding.default
        case .fetchCommonQuest, .deleteCommonQuest:
            return  URLEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .postCommonQuest, .updateCommonQuest, .deleteCommonQuest:
            return nil
        case .fetchCommonQuest(let date, let cursor):
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
        case .postCommonQuest(_, let dto):
            return try? dto.toDictionary()
        case .fetchCommonQuest, .deleteCommonQuest:
            return nil
        case .updateCommonQuest(_, let dto):
            return try? dto.toDictionary()
        }
    }
}
