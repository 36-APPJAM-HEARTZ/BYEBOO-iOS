//
//  BlocksAPI.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/5/26.
//

import Foundation

import Alamofire

enum BlocksAPI {
    case getBlockList
    case blockUser(userID: Int)
    case deleteBlockUser(userID: Int)
}

extension BlocksAPI: EndPoint {
    var basePath: String {
        return "/api/v1/blocks"
    }
    
    var path: String {
        switch self {
        case .getBlockList:
            return ""
        case .blockUser(let userID), .deleteBlockUser(let userID):
            return "/\(userID)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getBlockList:
            return .get
        case .blockUser:
            return .post
        case .deleteBlockUser:
            return .delete
        }
    }
    
    var headers: HeaderType {
        let keychainService = DefaultKeychainService()
        return .withAuth(acessToken: keychainService.load(key: .accessToken))
    }
    
    var parameterEncoding: any Alamofire.ParameterEncoding {
        switch self {
        case .blockUser:
            return JSONEncoding.default
        case .getBlockList, .deleteBlockUser:
            return URLEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        nil
    }
    
    var bodyParameters: Alamofire.Parameters? {
        nil
    }
}
