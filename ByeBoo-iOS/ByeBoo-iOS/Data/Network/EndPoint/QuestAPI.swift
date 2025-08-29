//
//  QuestAPI.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Foundation

import Alamofire

enum QuestAPI {
    case checkQuest(questID: Int)
    case recording(questID: Int, request: SaveQuestRequestDTO)
    case active(questID: Int, request: SaveQuestActiveRequestDTO)
    case images(request: SignedURLRequestDTO)
    case tip(questID: Int)
    case answer(questID: Int)
    case progressingQuests
    case journey
    case postJourney(journey: JourneyType)
}

extension QuestAPI: EndPoint {
    
    var basePath: String {
        return "/api/v1/quests"
    }
    
    var path: String {
        switch self {
        case .checkQuest(let questID):
            return "/\(questID)"
        case .recording(let questID, _):
            return "/\(questID)/recording"
        case .active(let questID, _):
            return "/\(questID)/active"
        case .images:
            return "/images/signed-url"
        case .tip(let questID):
            return "/\(questID)/tip"
        case .answer(let questID):
            return "/answer/\(questID)"
        case .progressingQuests:
            return "/all/progress"
        case .journey:
            return "/journey"
        case .postJourney(let journey):
            return "/journey=\(journey.key)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkQuest, .tip, .answer, .progressingQuests, .journey:
            return .get
        case .recording, .active, .images, .postJourney:
            return .post
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .checkQuest, .recording, .active, .tip, .images, .answer, .progressingQuests, .journey, .postJourney:
            return .withAuth(acessToken: Bundle.main.infoDictionary?["MASTER_TOKEN"] as! String)
        }
    }
    
    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .checkQuest, .tip, .answer, .progressingQuests, .journey, .postJourney:
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
        case let .recording(_, dto):
            return try? dto.toDictionary()
        case let .active(_, dto):
            return try? dto.toDictionary()
        case let .images(dto):
            return try? dto.toDictionary()
        case .checkQuest, .tip, .answer, .progressingQuests, .journey, .postJourney:
            return nil
        }
    }
    
}
