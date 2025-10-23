//
//  QuestTests.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 10/23/25.
//

import Testing
@testable import ByeBoo_iOS

struct QuestTests {
    
    private let questsRepository = MockQuestsRepository()
    
    @Test("🏁 진행 중인 퀘스트 조회 ✅ success")
    func fetchProgressingQuests__success() async throws {
        let fetchProgressingQuestsUseCase = DefaultGetProgressingQuestsUseCase(repository: questsRepository)
        
        let result = try await fetchProgressingQuestsUseCase.execute()
        
        #expect(result.currentStep == 30)
        #expect(result.progressPeriod == 30)
        #expect(result.questOpenTime == nil)
        #expect(result.currentTime == nil)
        #expect(result.steps.count == 5)
    }
    
    @Test("🏁 단일 퀘스트 조회 ✅ success")
    func fetchQuestInformation__success() async throws {
        let getQuestInfoUseCase = DefaultGetQuestInfoUseCase(questInfoReposiroty: questsRepository)
        
        let result = try await getQuestInfoUseCase.execute(questID: 1)
        
        #expect(result.step == "1")
        #expect(result.stepNumber == 1)
        #expect(result.questNumber == 1)
        #expect(result.questStyle == "quest style")
        #expect(result.question == "question")
    }
    
    @Test("🏁 퀘스트에 대한 사용자 답변 조회 ✅ success")
    func fetchQuestAnswer__success() async throws {
        let fetchQuestAnswerUseCase = DefaultQuestAnswerUseCase(questAnswerRepository: questsRepository)
        
        let result = try await fetchQuestAnswerUseCase.execute(questID: 1)
        
        #expect(result.stepNumber == 1)
        #expect(result.questNumber == 1)
        #expect(result.createdAt == "2025-07-18")
        #expect(result.question == "어쩌구 저쩌구 question")
        #expect(result.answer == "답변입니다 ~")
        #expect(result.questEmotionState == "mock emotion state")
        #expect(result.emotionDescription == "mock emotion description")
    }
    
    @Test("🏁 완료된 여정의 퀘스트 조회 ✅ success")
    func fetchCompletedQuests__success() async throws {
        let fetchCompletedQuestsUseCase = DefaultFetchCompletedQuestsUseCase(repository: questsRepository)
        
        let result = try await fetchCompletedQuestsUseCase.execute(journey: .face)
        
        #expect(result.progressPeriod == "2025-08-28 ~ 2025-09-01")
        #expect(result.currentStep == nil)
        #expect(result.steps.count == 5)
    }
}
