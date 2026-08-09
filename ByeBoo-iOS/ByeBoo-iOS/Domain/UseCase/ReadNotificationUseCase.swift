//
//  ReadNotificationUseCase.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/8/26.
//

protocol ReadNotificationUseCase {
    func execute(for notificationID: Int) async throws
}

struct DefaultReadNotificationUseCase: ReadNotificationUseCase {
    
    private let repository: NotificationInterface
    
    init(repository: NotificationInterface) {
        self.repository = repository
    }
    
    func execute(for notificationID: Int) async throws {
        try await repository.readNotification(for: notificationID)
    }
}
