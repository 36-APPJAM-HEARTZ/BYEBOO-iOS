//
//  AuthAPI.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/26/25.
//

import Foundation

import Alamofire

enum AuthAPI {
    case login(header: HeaderType, requestDTO: LoginRequestDTO)
    case reissue(header: HeaderType)
    case logout(header: HeaderType)
    case withdraw(header: HeaderType)
}

extension AuthAPI: EndPoint {
    var basePath: String {
        return "/api/v1/auth"
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .reissue:
            return "/reissue"
        case .logout:
            return "/logout"
        case .withdraw:
            return "/withdraw"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login, .reissue:
            return .post
        case .logout, .withdraw:
            return .delete
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .login(let header, _),
            .reissue(let header),
            .logout(let header),
            .withdraw(let header):
            return header
        }
    }
    
    var parameterEncoding: any Alamofire.ParameterEncoding {
        switch self {
        case .login, .reissue:
            return JSONEncoding.default
        case .logout, .withdraw:
            return URLEncoding.default
        }

    }
    
    var queryParameters: [String : String]? {
        nil
    }
    
    var bodyParameters: Alamofire.Parameters? {
        switch self {
        case .login(_, let dto):
            return try? dto.toDictionary()
        case .reissue, .logout, .withdraw:
            return nil
        }

    }
    
    
}
