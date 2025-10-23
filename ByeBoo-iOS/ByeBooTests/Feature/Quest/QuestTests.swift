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
        
        #expect(result == ProgressingQuestsEntity.stub())
    }
    
    @Test("🏁 단일 퀘스트 조회 ✅ success")
    func fetchQuestInformation__success() async throws {
        let getQuestInfoUseCase = DefaultGetQuestInfoUseCase(questInfoReposiroty: questsRepository)
        
        let result = try await getQuestInfoUseCase.execute(questID: 1)
        
        #expect(result == QuestInfoEntity.stub())
    }
    
    @Test("🏁 퀘스트에 대한 사용자 답변 조회 ✅ success")
    func fetchQuestAnswer__success() async throws {
        let fetchQuestAnswerUseCase = DefaultQuestAnswerUseCase(questAnswerRepository: questsRepository)
        
        let result = try await fetchQuestAnswerUseCase.execute(questID: 1)
        
        #expect(result == QuestAnswerEntity.stub())
    }
    
    @Test("🏁 퀘스트 팁 조회 ✅ success")
    func fetchQuestTip__success() async throws {
        let fetchQuestTipUseCase = DefaultQuestTipUseCase(questTipRepository: questsRepository)
        
        let result = try await fetchQuestTipUseCase.fetchQuestTips(questID: 1)
        
        #expect(result == QuestTipDataEntity.stub())
    }
    
    
    @Test("🏁 완료된 여정의 퀘스트 조회 ✅ success")
    func fetchCompletedQuests__success() async throws {
        let fetchCompletedQuestsUseCase = DefaultFetchCompletedQuestsUseCase(repository: questsRepository)
        
        let result = try await fetchCompletedQuestsUseCase.execute(journey: .face)
        
        #expect(result == CompletedQuestsEntity.stub())
    }
}
