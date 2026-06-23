//
//  NotificationInterface.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/5/26.
//

protocol NotificationInterface {
    func fetchNotifications() async throws -> NotificationListEntity
    func fetchHasUnreadNotification() async throws -> HasUnreadNotificationEntity
    func readNotification(for notificationID: Int) async throws
    func readAllNotifications() async throws
}
