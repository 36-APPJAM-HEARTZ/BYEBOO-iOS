//
//  WithdrawUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/29/25.
//

import Foundation

protocol WithdrawUseCase {
    func execute() async throws -> Bool
}

struct DefaultWithdrawUseCase: WithdrawUseCase {
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> Bool {
        return try await repository.withdraw()
    }
}
