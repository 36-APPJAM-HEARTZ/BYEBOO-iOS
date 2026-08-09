//
//  NotificationRepository.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/5/26.
//

struct DefaultNotificationRepository: NotificationInterface {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchNotifications() async throws -> NotificationListEntity {
        let result = try await networkService.request(
            NotificationAPI.fetchNotificationList,
            decodingType: NotificationListResponseDTO.self
        )
        return result.toEntity()
    }
    
    func fetchHasUnreadNotification() async throws -> HasUnreadNotificationEntity {
        let result = try await networkService.request(
            NotificationAPI.fetchUnreadNotification,
            decodingType: HasUnreadNotificationResponseDTO.self
        )
        return result.toEntity()
    }
    
    func readNotification(for notificationID: Int) async throws {
        try await networkService.request(NotificationAPI.readNotification(notificationID: notificationID))
    }
    
    func readAllNotifications() async throws {
        try await networkService.request(NotificationAPI.readAllNotifications)
    }
}
