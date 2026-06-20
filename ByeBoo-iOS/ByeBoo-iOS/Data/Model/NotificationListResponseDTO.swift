//
//  NotificationListResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/5/26.
//

struct NotificationListResponseDTO: Decodable {
    let notifications: [NotificationResponseDTO]
}

struct NotificationResponseDTO: Decodable {
    let notificationId: Int
    let content: String
    let title: String
    let isRead: Bool
    let createdAt: String
    let landingUrl: String
    let notificationType: String
}

extension NotificationListResponseDTO {
    func toEntity() -> NotificationListEntity {
        let notifications = notifications.map { $0.toEntity() }
        return .init(notifications: notifications)
    }
}

extension NotificationResponseDTO {
    func toEntity() -> NotificationEntity {
        .init(
            notificationID: notificationId,
            notificationType: NotificationType.keyToEnum(notificationType),
            title: title,
            content: content,
            isRead: isRead,
            createdAt: createdAt,
            landingURL: landingUrl
        )
    }
}
