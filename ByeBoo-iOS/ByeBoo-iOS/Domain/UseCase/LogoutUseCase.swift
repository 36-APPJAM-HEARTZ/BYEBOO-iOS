//
//  LogoutUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/29/25.
//

import Foundation

protocol LogoutUseCase {
    func execute() async throws -> Bool
}

struct DefaultLogoutUseCase: LogoutUseCase {
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> Bool {
        return try await repository.logout()
    }
}
