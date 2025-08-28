//
//  AuthAPI.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/26/25.
//

import Foundation

import Alamofire

enum AuthAPI {
    case login(requestDTO: LoginRequestDTO)
    case reissue
    case logout
    case withdraw
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
        let keychainService = DefaultKeychainService()
        let userDefaultsService = DefaultUserDefaultService()
        switch self {
        case .login:
            return .withAuth(acessToken: keychainService.load(key: .authorization))
        case .reissue:
            return .withAuth(acessToken: keychainService.load(key: .refreshToken))
        case .logout:
            return .withAuth(acessToken: keychainService.load(key: .accessToken))
        case .withdraw:
            let loginPlatform: String? = userDefaultsService.load(key: .loginPlatcform)
            guard let loginPlatform = loginPlatform else {
               return .withAuth(acessToken: keychainService.load(key: .accessToken))
            }
            
            switch loginPlatform {
            case "KAKAO":
                return .withAuth(acessToken: keychainService.load(key: .accessToken))
            case "APPLE":
                return .withAuthCode(
                    acessToken: keychainService.load(key: .accessToken),
                    authorizationCode: keychainService.load(key: .authorizationCode)
                )
            default :
                ByeBooLogger.debug("login Platform 없음")
                return .withAuth(acessToken: keychainService.load(key: .accessToken))
            }
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
        case .login(let dto):
            return try? dto.toDictionary()
        case .reissue, .logout, .withdraw:
            return nil
        }

    }
    
    
}
