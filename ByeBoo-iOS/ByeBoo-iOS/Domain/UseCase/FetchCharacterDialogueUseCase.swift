//
//  FetchCharacterDialogueUseCase.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/14/25.
//

protocol FetchCharacterDialogueUseCase {
    func execute() async throws -> String
}

struct DefaultFetchCharacterDialogueUseCase: FetchCharacterDialogueUseCase {
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> String {
        return try await repository.fetchCharacterDialogue()
    }
}

struct MockFetchCharacterDialogueUseCase: FetchCharacterDialogueUseCase {
    func execute() async throws -> String {
        return "하츠핑님의 이별 극복을 도와드릴게요"
    }
}
