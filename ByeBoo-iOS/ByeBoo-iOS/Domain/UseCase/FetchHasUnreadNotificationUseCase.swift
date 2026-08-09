//
//  FetchHasUnreadNotificationUseCase.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/19/26.
//

protocol FetchHasUnreadNotificationUseCase {
    func execute() async throws -> HasUnreadNotificationEntity
}

struct DefaultFetchHasUnreadNotificationUseCase: FetchHasUnreadNotificationUseCase {
    
    private let repository: NotificationInterface
    
    init(repository: NotificationInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> HasUnreadNotificationEntity {
        let result = try await repository.fetchHasUnreadNotification()
        return result
    }
}
