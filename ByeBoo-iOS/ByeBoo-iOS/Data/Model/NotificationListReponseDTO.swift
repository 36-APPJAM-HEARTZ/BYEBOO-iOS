//
//  NotificationListReponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/5/26.
//

struct NotificationListReponseDTO: Decodable {
    let notifications: [NotificationResponseDTO]
}

struct NotificationResponseDTO: Decodable {
    let notificationID: Int
    let notificationType: String
    let title: String
    let content: String
    let isRead: Bool
    let createdAt: String
    let landingURL: String
}

extension NotificationListReponseDTO {
    func toEntity() -> NotificationListEntity {
        let notifications = notifications.map { $0.toEntity() }
        return .init(notifications: notifications)
    }
}

extension NotificationResponseDTO {
    func toEntity() -> NotificationEntity {
        .init(
            notificationID: notificationID,
            notificationType: notificationType,
            title: title,
            content: content,
            isRead: isRead,
            createdAt: createdAt,
            landingURL: landingURL
        )
    }
}
