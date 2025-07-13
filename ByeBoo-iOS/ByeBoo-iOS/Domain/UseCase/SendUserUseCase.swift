//
//  SendUserUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/13/25.
//

import Foundation

protocol SendUserUseCase {
    func execute(name: String, feeling: String, questStyle: String) async throws -> UserEntity
}

struct DefaultSenduserUseCase: SendUserUseCase {
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute(
        name: String,
        feeling: String,
        questStyle: String
    ) async throws -> UserEntity {
        try await repository.sendUser(
            name: name,
            feeling: feeling,
            questStyle: questStyle
        )
    }
}
