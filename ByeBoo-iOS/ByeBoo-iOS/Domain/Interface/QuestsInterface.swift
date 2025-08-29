//
//  QuestsInterface.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/18/25.
//

import Foundation

protocol QuestsInterface {
    func fetchProgressingQuests(userID: Int) async throws -> ProgressingQuestsEntity
    func getQuestInfo(questID: Int) async throws -> QuestInfoEntity
    func fetchQuestAnswer(questID: Int) async throws -> QuestAnswerEntity
    func fetchQuestTips(questID: Int) async throws -> QuestTipDataEntity
    func postActiveQuest(
        questID: Int,
        answer: String,
        emotionState: String,
        image: Data,
        imageKey: String) async throws
    func postQuestionQuest(questID: Int, answer: String, emotionState: String) async throws
    func getLookBackJourney() async throws -> [JourneyEntity]
    func getNewJourney() async throws -> LookBackJourneyEntity
    func postNewJourney(journey: JourneyType) async throws
}
