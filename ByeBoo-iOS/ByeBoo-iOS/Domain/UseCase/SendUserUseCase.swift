//
//  SendUserUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/13/25.
//

import Foundation

protocol SendUserUseCase {
    func execute(user: UserRequestDTO) async throws -> UserEntity
}

struct DefaultSenduserUseCase: SendUserUseCase {
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute(user: UserRequestDTO) async throws -> UserEntity {
        try await repository.sendUser(user: user)
    }
}
