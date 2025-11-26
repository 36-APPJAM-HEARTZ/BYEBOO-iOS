//
//  ChangeNotificationPermissionUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 11/25/25.
//

protocol ChangeNotificationPermissionUseCase {
    func execute() async throws -> Bool
}

struct DefaultChangeNotificationPermissionUseCase: ChangeNotificationPermissionUseCase {
    
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> Bool {
        return try await repository.updateNotificationPermission()
    }
}
