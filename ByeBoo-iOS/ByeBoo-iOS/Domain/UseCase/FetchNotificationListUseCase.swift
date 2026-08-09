//
//  FetchNotificationListUseCase.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/5/26.
//

protocol FetchNotificationListUseCase {
    func execute() async throws -> NotificationListEntity
}

struct DefaultFetchNotificationListUseCase: FetchNotificationListUseCase {
    
    private let repository: NotificationInterface
    
    init(repository: NotificationInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> NotificationListEntity {
        try await repository.fetchNotifications()
    }
}
