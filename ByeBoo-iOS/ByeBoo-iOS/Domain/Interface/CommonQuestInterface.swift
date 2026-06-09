//
//  CommonQuestInterface.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/1/26.
//

import Foundation

protocol CommonQuestInterface {
    func saveCommonQuest(questID: Int, answer: String) async throws
    func fetchCommonQuest(date: String, cursor: Int?) async throws -> CommonQuestAnswersEntity
    func updateCommonQuest(answerID: Int, answer: String) async throws
    func deleteCommonQuest(answerID: Int) async throws
    func fetchCommonQuestDetail(answerID: Int) async throws -> CommonQuestDetailEntity
}
