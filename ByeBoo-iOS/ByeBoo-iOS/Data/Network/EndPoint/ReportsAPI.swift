//
//  ReportsAPI.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/5/26.
//

import Foundation

import Alamofire

enum ReportsAPI {
    case postReport(answerID: Int)
}

extension ReportsAPI: EndPoint {
    var basePath: String {
        return "/api/v1/reports"
    }
    
    var path: String {
        switch self {
        case .postReport(let answerID):
            return "/common-quests/\(answerID)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .postReport:
            return .post
        }
    }
    
    var headers: HeaderType {
        let keychainService = DefaultKeychainService()
        return .withAuth(acessToken: keychainService.load(key: .accessToken))
    }
    
    var parameterEncoding: any Alamofire.ParameterEncoding {
        switch self {
        case .postReport:
            return JSONEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        nil
    }
    
    var bodyParameters: Alamofire.Parameters? {
        nil
    }
    
    
}
