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
    case fetchUnreadNotification
}

extension NotificationAPI: EndPoint {
    
    var basePath: String {
        return "/api/v1/notifications"
    }
    
    var path: String {
        switch self {
        case .fetchNotificationList:
            ""
        case .fetchUnreadNotification:
            "/unread/status"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchNotificationList, .fetchUnreadNotification:
                .get
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .fetchNotificationList, .fetchUnreadNotification:
                .withAuth
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchNotificationList, .fetchUnreadNotification:
            JSONEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchNotificationList, .fetchUnreadNotification:
            nil
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchNotificationList ,.fetchUnreadNotification:
            nil
        }
    }
}
