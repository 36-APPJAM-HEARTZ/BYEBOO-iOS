//
//  EndPoint.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/28/25.
//

import Foundation

import Alamofire

protocol EndPoint {
    /// ex ) /api/v1/quests/journey?journey={journey}
    ///
    /// basePath - /api/v1/quests
    /// path - /journey
    /// method - get
    /// headers - .withAuth(userID: Int)
    /// parameterEncoding - URLEncoding / JSONEncoding
    /// queryParameters - [journey: journey]
    /// bodyParameters - nil
    ///
    var basePath: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HeaderType { get }
    var parameterEncoding: ParameterEncoding { get }
    var queryParameters: [String: String]? { get }
    var bodyParameters: Parameters? { get }
    
    var requestURL: URL { get }
}

extension EndPoint {
    var requestURL: URL {
        // TODO: config에서 빼온 base url
        let baseURL: String = ""
        let urlString = baseURL + basePath + path
        
        guard var urlComponents = URLComponents(string: urlString) else {
            ByeBooLogger.error(ByeBooError.URLError)
            return URL(string: "")!
        }
        
        if let queryParameters {
            urlComponents.queryItems = queryParameters.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        guard let url = urlComponents.url else {
            ByeBooLogger.error(ByeBooError.URLError)
            return URL(string: "")!
        }
        
        return url
    }
}

enum HeaderType {
    case basic
    case withAuth(userID: Int)
    
    var value: HTTPHeaders {
        switch self {
        case .basic:
            return ["Content-Type": "application/json"]
        case .withAuth(let userID):
            return [
                "Content-Type": "application/json",
                "userId": "\(userID)"
            ]
        }
    }
}
