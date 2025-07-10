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
}

extension UsersAPI: EndPoint {
    var basePath: String {
        return "/api/v1/users"
    }
    
    var path: String {
        switch self {
        case .journey:
            return "/journey"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .journey:
            return .get
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .journey(let userID):
            return .withAuth(userID: userID)
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var queryParameters: [String : String]? {
        nil
    }
    
    var bodyParameters: Parameters? {
        nil
    }
    
    
}
