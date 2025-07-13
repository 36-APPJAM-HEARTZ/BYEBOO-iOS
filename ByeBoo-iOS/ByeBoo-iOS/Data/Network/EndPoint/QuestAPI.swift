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
    case recording(userID: Int, questID: Int)
    case active(userID: Int, questID: Int)
    case images(userID: Int)
    case tip(userID: Int, questID: Int)
}

extension QuestAPI: EndPoint {
    
    var basePath: String {
        return "/api/v1/quests"
    }
    
    var path: String {
        switch self {
        case .checkQuest(_, let questID):
            return "/\(questID)"
        case .recording(_, let questID):
            return "/\(questID)/recording"
        case .active(_, let questID):
            return "/\(questID)/active"
        case .images:
            return "/images/signed-url"
        case .tip(_, let questID):
            return "/\(questID)/tip"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkQuest, .tip:
            return .get
        case .recording, .active, .images:
            return .post
        }
    }
    
    var headers: HeaderType {
        switch self {
        case let .checkQuest(userID, _),
            let .recording(userID, _),
            let .active(userID, _),
            let .tip(userID, _),
            let .images(userID):
            return .withAuth(userID: userID)
        }
    }
    
    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .checkQuest, .tip:
            return URLEncoding.default
        case .recording, .active, .images:
            return JSONEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case let .checkQuest(_, questID):
            return ["questID": "\(questID)"]
        case let .recording(_, questID):
            return ["questID": "\(questID)"]
        case let .active(_, questID):
            return ["questID": "\(questID)"]
        case let .tip(_, questID):
            return ["questID": "\(questID)"]
        case .images:
            return nil
        }
    }
    
    var bodyParameters: Parameters? {
        nil
    }
    
}
