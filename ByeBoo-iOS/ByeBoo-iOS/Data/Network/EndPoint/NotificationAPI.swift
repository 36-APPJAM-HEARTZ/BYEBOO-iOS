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
    case readAllNotifications
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
        case .readAllNotifications:
            "/read-all"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchNotificationList, .fetchUnreadNotification:
                .get
        case .readNotification, .readAllNotifications:
                .patch
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .fetchNotificationList, .fetchUnreadNotification, .readNotification, .readAllNotifications:
                .withAuth
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchNotificationList, .fetchUnreadNotification:
            JSONEncoding.default
        case .readNotification, .readAllNotifications:
            URLEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .fetchNotificationList, .fetchUnreadNotification, .readNotification, .readAllNotifications:
            nil
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .fetchNotificationList, .fetchUnreadNotification, .readNotification, .readAllNotifications:
            nil
        }
    }
}
