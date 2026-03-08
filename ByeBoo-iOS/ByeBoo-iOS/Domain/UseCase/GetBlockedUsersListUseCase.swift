//
//  GetBlockedUsersListUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/9/26.
//

protocol GetBlockedUsersListUseCase {
    func execute() async throws -> [BlockedUserEntity]
}

struct DefaultGetBlockedUsersListUseCase: GetBlockedUsersListUseCase {
    private let repository: BlocksInterface
    
    init(repository: BlocksInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> [BlockedUserEntity] {
        return try await repository.getBlockedUsersList()
    }
}
