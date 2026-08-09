//
//  ReportsAPI.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/5/26.
//

import Foundation

import Alamofire

enum ReportsAPI {
    case postReport(dto: ReportRequestDTO)
}

extension ReportsAPI: EndPoint {
    var basePath: String {
        return "/api/v2/reports"
    }
    
    var path: String {
        switch self {
        case .postReport:
            return ""
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .postReport:
            return .post
        }
    }
    
    var headers: HeaderType {
        return .withAuth
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
        switch self {
        case .postReport(let dto):
            return try? dto.toDictionary()
        }
    }
}
