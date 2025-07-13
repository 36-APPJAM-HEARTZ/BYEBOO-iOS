//
//  QuestAnswerInterface.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

protocol QuestAnswerInterface {
    func fetchQuestAnswer() async throws -> QuestAnswerEntity
}

