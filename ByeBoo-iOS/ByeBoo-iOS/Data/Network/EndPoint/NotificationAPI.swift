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
        case .fetchUnreadNotification:
            "/unread/status"
        case .readNotification(let notificationID):
            "/\(notificationID)/read"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchNotificationList, .fetchUnreadNotification:
                .get
        case .readNotification:
                .patch
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .fetchNotificationList, .fetchUnreadNotification, .readNotification:
                .withAuth
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchNotificationList, .fetchUnreadNotification:
            JSONEncoding.default
        case .readNotification:
            URLEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchNotificationList, .fetchUnreadNotification, .readNotification:
            nil
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchNotificationList, .fetchUnreadNotification, .readNotification:
            nil
        }
    }
}
