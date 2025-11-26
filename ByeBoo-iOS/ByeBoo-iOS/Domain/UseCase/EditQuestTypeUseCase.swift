//
//  EditQuestTypeUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 11/25/25.
//

protocol EditQuestTypeUseCase {
    func execute(questID: Int, answer: String) async throws
}

struct DefaultEditQuestTypeUseCase: EditQuestTypeUseCase {
    private let repository: QuestsInterface
    
    init(repository: QuestsInterface) {
        self.repository = repository
    }
    
    func execute(questID: Int, answer: String) async throws {
        try await repository.editQuestionQuest(
            questID: questID,
            answer: answer
        )
    }
}
