//
//  NotificationListEntity.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/5/26.
//

struct NotificationListEntity {
    let notifications: [NotificationEntity]
}

struct NotificationEntity {
    let notificationID: Int
    let notificationType: String
    let title: String
    let content: String
    let isRead: Bool
    let createdAt: String
    let landingURL: String
}
