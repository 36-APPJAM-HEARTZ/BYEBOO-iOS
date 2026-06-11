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
    case readNotification(notificationID: Int)
}

extension NotificationAPI: EndPoint {
    
    var basePath: String {
        return "/api/v1/notifications"
    }
    
    var path: String {
        switch self {
        case .fetchNotificationList:
            ""
        case .readNotification(let notificationID):
            "/\(notificationID)/read"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchNotificationList:
                .get
        case .readNotification:
                .patch
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .fetchNotificationList, .readNotification:
                .withAuth
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchNotificationList:
            JSONEncoding.default
        case .readNotification:
            URLEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchNotificationList, .readNotification:
            nil
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchNotificationList, .readNotification:
            nil
        }
    }
}
