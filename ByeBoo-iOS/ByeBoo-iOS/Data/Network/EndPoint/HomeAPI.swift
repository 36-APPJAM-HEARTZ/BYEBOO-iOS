//
//  HomeAPI.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/6/25.
//

import Foundation

import Alamofire

enum HomeAPI {
    case character(userID: Int)
    case count(userID: Int)
}

extension HomeAPI: EndPoint {
    var basePath: String {
        "/api/v1/home"
    }
    
    var path: String {
        switch self {
        case .character:
            "/character"
        case .count:
            "/count"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .character, .count:
                .get
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .character(let userID), .count(let userID):
                .withAuth(userID: userID)
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .character, .count:
            URLEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .character, .count:
            nil
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .character, .count:
            nil
        }
    }
}
