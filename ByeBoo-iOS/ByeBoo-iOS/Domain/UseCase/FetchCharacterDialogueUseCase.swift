//
//  FetchCharacterDialogueUseCase.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/14/25.
//

protocol FetchCharacterDialogueUseCase {
    func execute() async throws -> DialogueEntity
}

struct DefaultFetchCharacterDialogueUseCase: FetchCharacterDialogueUseCase {
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> DialogueEntity {
        return try await repository.fetchCharacterDialogue()
    }
}
