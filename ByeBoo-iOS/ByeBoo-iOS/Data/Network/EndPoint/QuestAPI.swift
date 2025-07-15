//
//  QuestAPI.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Foundation

import Alamofire

enum QuestAPI {
    case checkQuest(userID: Int, questID: Int)
    case recording(userID: Int, questID: Int, request: SaveQuestRequestDTO)
    case active(userID: Int, questID: Int, request: SaveQuestActiveRequestDTO)
    case images(userID: Int, request: SignedURLRequestDTO)
    case tip(userID: Int, questID: Int)
    case answer(userID: Int, questID: Int)
    case progressingQuests(userID: Int)
}

extension QuestAPI: EndPoint {
    
    var basePath: String {
        return "/api/v1/quests"
    }
    
    var path: String {
        switch self {
        case .checkQuest(_, let questID):
            return "/\(questID)"
        case .recording(_, let questID, _):
            return "/\(questID)/recording"
        case .active(_, let questID, _):
            return "/\(questID)/active"
        case .images:
            return "/images/signed-url"
        case .tip(_, let questID):
            return "/\(questID)/tip"
        case .answer(_, let questID):
            return "/answer/\(questID)"
        case .progressingQuests:
            return "/all/progress"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkQuest, .tip, .answer, .progressingQuests:
            return .get
        case .recording, .active, .images:
            return .post
        }
    }
    
    var headers: HeaderType {
        switch self {
        case let .checkQuest(userID, _),
            let .recording(userID, _, _),
            let .active(userID, _, _),
            let .tip(userID, _),
            let .images(userID, _),
            let .answer(userID, _):
            let .images(userID),
            let .answer(userID, _),
            let .progressingQuests(userID):
            return .withAuth(userID: userID)
        }
    }
    
    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .checkQuest, .tip, .answer, .progressingQuests:
            return URLEncoding.default
        case .recording, .active, .images:
            return JSONEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case let .recording(_, _, dto):
            return try? dto.toDictionary()
        case let .active(_, _, dto):
            return try? dto.toDictionary()
        case let .images(_, dto):
            return try? dto.toDictionary()
        case .checkQuest, .tip, .answer, .progressingQuests:
            return nil
        }
    }
    
}
