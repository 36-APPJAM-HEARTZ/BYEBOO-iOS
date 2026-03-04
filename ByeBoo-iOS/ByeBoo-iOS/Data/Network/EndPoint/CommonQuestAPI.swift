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
}

extension CommonQuestAPI: EndPoint {
    
    var basePath: String {
        return "/api/v1/common-quests"
    }
    
    var path: String {
        switch self {
        case .postCommonQuest(let questID, _):
            return "/\(questID)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postCommonQuest:
            return .post
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .postCommonQuest:
            let keychainService = DefaultKeychainService()
            return .withAuth(acessToken: keychainService.load(key: .accessToken))
        }
    }
    
    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .postCommonQuest:
            return JSONEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
      nil
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .postCommonQuest(_, let dto):
            return try? dto.toDictionary()
        }
    }
}
