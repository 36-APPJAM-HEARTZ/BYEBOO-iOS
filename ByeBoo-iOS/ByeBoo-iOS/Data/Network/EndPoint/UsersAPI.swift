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
        case .modifyName:
            return "/name"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .journey, .character, .count:
            return .get
        case .sendUser, .start, .modifyName:
            return .patch
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .journey, .sendUser, .character, .count, .start, .modifyName:
            let keychainService = DefaultKeychainService()
            return .withAuth(acessToken: keychainService.load(key: .accessToken))
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .journey, .character, .count, .start:
            return URLEncoding.default
        case .sendUser, .modifyName:
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
        case .modifyName(let dto):
            return try? dto.toDictionary()
        }
    }
}

