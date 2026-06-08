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
}
