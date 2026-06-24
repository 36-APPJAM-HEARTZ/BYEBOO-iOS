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
    let notificationType: NotificationType?
    let title: String
    let content: String
    let isRead: Bool
    let createdAt: String
    let landingURL: String
}

extension NotificationListEntity {
    static func stub() -> Self {
        .init(
            notifications: [
                NotificationEntity(
                    notificationID: 9,
                    notificationType: .questOpen,
                    title: "오늘의 퀘스트 오픈 🌱",
                    content: "3번째 퀘스트가 오픈됐어요, 시작해볼까요?",
                    isRead: false,
                    createdAt: "2026-06-07T11:29:00.735730",
                    landingURL: "myapp://quest/3"
                ),
                NotificationEntity(
                    notificationID: 8,
                    notificationType: .comment,
                    title: "공통여정에 답변이 달렸어요 💬",
                    content: "내가 작성한 글에 보리보리쌀님이 답변을 남겼어요",
                    isRead: true,
                    createdAt: "2026-06-07T08:35:43.735730",
                    landingURL: "myapp://common-quests/486"
                ),
                NotificationEntity(
                    notificationID: 7,
                    notificationType: .like,
                    title: "공통여정에 답변에 공감이 달렸어요 ❤️",
                    content: "내가 작성한 글에 보리보리쌀님이 공감을 남겼어요",
                    isRead: true,
                    createdAt: "2026-06-06T15:35:43.735730",
                    landingURL: "myapp://common-quests/486"
                ),
                NotificationEntity(
                    notificationID: 6,
                    notificationType: .questOpen,
                    title: "오늘의 퀘스트 오픈 🌱",
                    content: "3번째 퀘스트가 오픈됐어요, 시작해볼까요?",
                    isRead: false,
                    createdAt: "2026-02-19T02:09:43.735730",
                    landingURL: "myapp://quest/3"
                ),
                NotificationEntity(
                    notificationID: 5,
                    notificationType: .comment,
                    title: "공통여정에 답변이 달렸어요 💬",
                    content: "내가 작성한 글에 보리보리쌀님이 답변을 남겼어요",
                    isRead: true,
                    createdAt: "2026-02-19T02:09:43.735730",
                    landingURL: "myapp://common-quests/486"
                ),
                NotificationEntity(
                    notificationID: 4,
                    notificationType: .like,
                    title: "공통여정에 답변에 공감이 달렸어요 ❤️",
                    content: "내가 작성한 글에 보리보리쌀님이 공감을 남겼어요",
                    isRead: true,
                    createdAt: "2026-02-19T02:09:43.735730",
                    landingURL: "myapp://common-quests/486"
                )
            ]
        )
    }
}

extension NotificationEntity {
    func markAsRead() -> Self {
        .init(
            notificationID: notificationID,
            notificationType: notificationType,
            title: title,
            content: content,
            isRead: true,
            createdAt: createdAt,
            landingURL: landingURL
        )
    }
}
