//
//  EditActiveTypeQuestUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 11/25/25.
//

import Foundation

protocol EditQuestActiveUseCase {
    func execute(questID: Int, answer: String,image: Data?, imageKey: String, isImageChanged: Bool) async throws
}

struct DefaultEditQuestActiveUseCase: EditQuestActiveUseCase {
    private let repository: QuestsInterface
    
    init(repository: QuestsInterface) {
        self.repository = repository
    }
    
    func execute(questID: Int, answer: String, image: Data?, imageKey: String, isImageChanged: Bool) async throws {
        try await repository.editActiveQuest(
            questID: questID,
            answer: answer,
            image: image,
            imageKey: imageKey,
            isImageChanged: isImageChanged
        )
    }
}
