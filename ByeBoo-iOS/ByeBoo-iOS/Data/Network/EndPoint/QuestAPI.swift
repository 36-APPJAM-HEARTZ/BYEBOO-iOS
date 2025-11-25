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
    case fetchCompletedJourney
    case postJourney(journey: JourneyType)
    case completedQuests(journey: JourneyType)
    case editRecording(questID: Int, request: EditQuestRequestDTO)
    case editActive(questID: Int, request: EditQuestActiveRequestDTO)
}

extension QuestAPI: EndPoint {
    
    var basePath: String {
        return "/api/v1/quests"
    }
    
    var path: String {
        switch self {
        case .checkQuest(let questID):
            return "/\(questID)"
        case .recording(let questID, _), .editRecording(let questID, _):
            return "/\(questID)/recording"
        case .active(let questID, _), .editActive(let questID, _):
            return "/\(questID)/active"
        case .images:
            return "/images/signed-url"
        case .tip(let questID):
            return "/\(questID)/tip"
        case .answer(let questID):
            return "/answer/\(questID)"
        case .progressingQuests:
            return "/all/progress"
        case .fetchCompletedJourney, .postJourney:
            return "/journey"
        case .completedQuests:
            return "/all/completed"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkQuest, .tip, .answer, .progressingQuests, .fetchCompletedJourney, .completedQuests:
            return .get
        case .recording, .active, .images, .postJourney:
            return .post
        case .editRecording, .editActive:
            return .patch
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .checkQuest, .recording, .active, .tip, .images, .answer, .progressingQuests, .fetchCompletedJourney,
                .postJourney, .completedQuests, .editRecording, .editActive:
            let keychainService = DefaultKeychainService()
            return .withAuth(acessToken: keychainService.load(key: .accessToken))
        }
    }
    
    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .checkQuest, .tip, .answer, .progressingQuests, .fetchCompletedJourney, .postJourney, .completedQuests:
            return URLEncoding.default
        case .recording, .active, .images, .editRecording, .editActive:
            return JSONEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .postJourney(let journey), .completedQuests(let journey):
            return ["journey": journey.key]
        default:
            return nil
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case let .recording(_, dto):
            return try? dto.toDictionary()
        case let .active(_, dto):
            return try? dto.toDictionary()
        case let .images(dto):
            return try? dto.toDictionary()
        case let .editRecording(_, dto):
            return try? dto.toDictionary()
        case let .editActive(_, dto):
            return try? dto.toDictionary()
        case .checkQuest, .tip, .answer, .progressingQuests, .fetchCompletedJourney, .postJourney, .completedQuests:
            return nil
        }
    }
    
}
