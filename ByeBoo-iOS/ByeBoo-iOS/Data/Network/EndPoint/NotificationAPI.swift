//
//  NotificationAPI.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/5/26.
//

import Foundation

import Alamofire

enum NotificationAPI {
    case fetchNotificationList
}

extension NotificationAPI: EndPoint {
    
    var basePath: String {
        return "/api/v1/notifications"
    }
    
    var path: String {
        switch self {
        case .fetchNotificationList:
            ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchNotificationList:
                .get
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .fetchNotificationList:
                .withAuth
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchNotificationList:
            JSONEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchNotificationList:
            nil
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchNotificationList:
            nil
        }
    }
}
