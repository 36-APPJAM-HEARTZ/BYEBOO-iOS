//
//  ModifyNameUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/24/25.
//

protocol ModifyNicknameUseCase {
    func execute(name: String) async throws -> String
}

struct DefaultModifyNicknameUseCase: ModifyNicknameUseCase {
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute(name: String) async throws -> String {
        let name = try await repository.modifyUserNickname(name: name)
        return name
    }
}
