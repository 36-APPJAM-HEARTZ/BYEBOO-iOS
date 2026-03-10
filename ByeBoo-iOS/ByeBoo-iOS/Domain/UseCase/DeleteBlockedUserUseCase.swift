//
//  DeleteBlockedUserUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/9/26.
//

protocol DeleteBlockedUserUseCase {
    func execute(blockID: Int) async throws
}

struct DefaultDeleteBlockedUser: DeleteBlockedUserUseCase {
    private let repository: BlocksInterface
    
    init(repository: BlocksInterface) {
        self.repository = repository
    }
    
    func execute(blockID: Int) async throws {
        try await repository.deleteBlockedUser(blockID: blockID)
    }
}
