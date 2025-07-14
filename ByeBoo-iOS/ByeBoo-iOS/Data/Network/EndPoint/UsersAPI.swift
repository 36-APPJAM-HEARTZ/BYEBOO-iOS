//
//  UsersAPI.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

import Foundation

import Alamofire

enum UsersAPI {
    case journey(userID: Int)
    case sendUser(requestDTO: UserRequestDTO)
    case character(userID: Int)
    case count(userID: Int)
    case start(userID: Int)
}

extension UsersAPI: EndPoint {
    var basePath: String {
        return "/api/v1/users"
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
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .journey, .character, .count:
            return .get
        case .sendUser:
            return .post
        case .start:
            return .patch
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .journey(let userID), .character(let userID), .count(let userID), .start(let userID):
            return .withAuth(userID: userID)
        case .sendUser:
            return .basic
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .journey, .character, .count, .start:
            return URLEncoding.default
        case .sendUser:
            return JSONEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        nil
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .journey, .character, .count, .start:
            return nil
        case .sendUser(let dto):
            return try? dto.toDictionary()
        }
    }
}
