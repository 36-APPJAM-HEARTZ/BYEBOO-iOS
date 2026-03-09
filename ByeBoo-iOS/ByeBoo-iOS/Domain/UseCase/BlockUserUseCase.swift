//
//  BlockUserUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/7/26.
//

protocol BlockUserUseCase {
    func execute(userID: Int) async throws
}

struct DefaultBlockUserCase: BlockUserUseCase {
    private let repository: BlocksInterface
    
    init(repository: BlocksInterface) {
        self.repository = repository
    }
    
    func execute(userID: Int) async throws {
        try await repository.blockUser(userID: userID)
    }
}
