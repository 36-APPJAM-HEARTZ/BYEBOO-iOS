//
//  QuestTests.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 10/23/25.
//

import UIKit
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
    
    @Test("🏁 활동형 퀘스트 등록을 호출했을 때 ✅ postActiveQuestCalled == true")
    func postActiveQuest__postActiveQuestCalledFalse() async throws {
        guard let image = UIImage(systemName: "pencil")?.jpegData(compressionQuality: 0.1) else {
            return
        }
        let questsRepository = MockQuestsRepository()
        let saveQuestActiveUseCase = DefaultSaveQuestActiveUseCase(questActiveRepository: questsRepository)
        
        let _ = try await saveQuestActiveUseCase.execute(
            questID: 1,
            answer: "answer",
            emotionState: "emotionState",
            image: image,
            imageKey: "imageKey"
        )
        
        #expect(questsRepository.postActiveQuestCalled)
    }
    
    @Test("🏁 질문형 퀘스트 등록을 호출했을 때 ✅ postQuestionQuestCalled == true")
    func postActiveQuest__postQuestionQuestCalledFalse() async throws {
        let questsRepository = MockQuestsRepository()
        let saveQuestTypeUseCase = DefaultSaveQuestTypeUseCase(repository: questsRepository)
        
        let _ = try await saveQuestTypeUseCase.execute(
            questID: 1,
            answer: "answer",
            emotionState: "emotionState"
        )
        
        #expect(questsRepository.postQuestionQuestCalled)
    }
    
    @Test("🏁 완료한 여정 돌아보기 ✅ success")
    func fetchLookBackJourney__success() async throws {
        let getLookBackJourneyUseCase = DefaultGetLookBackJourneyUseCase(lookBackJourneyRepository: questsRepository)
        
        let result = try await getLookBackJourneyUseCase.execute()
        
        #expect(result == [JourneyEntity.stub()])
    }
    
    @Test("🏁 새로운 여정 조회 ✅ success")
    func fetchNewJourney__success() async throws {
        let getNewJourneyUseCase = DefaultGetNewJourneyUseCase(lookBackJourneyRepository: questsRepository)
        
        let result = try await getNewJourneyUseCase.execute()
        
        #expect(result == LookBackJourneyEntity.stub())
    }
    
    @Test("🏁 새로운 여정 시작하기를 호출했을 때 ✅ postNewJourneyCalled == true")
    func postNewJourney__success() async throws {
        let questsRepository = MockQuestsRepository()
        let fetchNewJourneyUseCase = DefaultFetchNewJourneyUseCase(fetchNewJourneyRepository: questsRepository)
        
        let _ = try await fetchNewJourneyUseCase.execute(journey: .face)
        
        #expect(questsRepository.postNewJourneyCalled)
    }
    
    @Test("🏁 완료된 여정의 퀘스트 조회 ✅ success")
    func fetchCompletedQuests__success() async throws {
        let fetchCompletedQuestsUseCase = DefaultFetchCompletedQuestsUseCase(repository: questsRepository)
        
        let result = try await fetchCompletedQuestsUseCase.execute(journey: .face)
        
        #expect(result == CompletedQuestsEntity.stub())
    }
}
