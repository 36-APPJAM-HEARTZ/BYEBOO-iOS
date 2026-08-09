//
//  ReadAllNotificationsUseCase.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/23/26.
//

protocol ReadAllNotificationsUseCase {
    func execute() async throws
}

struct DefaultReadAllNotificationsUseCase: ReadAllNotificationsUseCase {
    
    private let repository: NotificationInterface
    
    init(repository: NotificationInterface) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.readAllNotifications()
    }
}
