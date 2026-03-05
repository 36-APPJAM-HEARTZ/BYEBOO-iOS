//
//  QuestsRepository.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/18/25.
//

import Foundation

struct DefaultQuestRepository: QuestsInterface {
    
    private let network: NetworkService
    private let userDefaultsService: UserDefaultService
    
    init(
        network: NetworkService,
        userDefaultsService: UserDefaultService
    ) {
        self.network = network
        self.userDefaultsService = userDefaultsService
    }
    
    func fetchProgressingQuests() async throws -> ProgressingQuestsEntity {
        let result = try await network.request(
            QuestAPI.progressingQuests,
            decodingType: ProgressingQuestsResponseDTO.self
        )
        return result.toEntity()
    }
    
    func getQuestInfo(questID: Int) async throws -> QuestInfoEntity {
        let result = try await network.request(
            QuestAPI.checkQuest(questID: questID),
            decodingType: QuestInfoResponseDTO.self
        )
        return result.toEntity()
    }
    
    func fetchQuestAnswer(questID: Int) async throws -> QuestAnswerEntity {
        let result = try await network.request(
            QuestAPI.answer(questID: questID),
            decodingType: QuestAnswerResponseDTO.self
        )
        return result.toEntity()
    }
    
    func fetchQuestTips(questID: Int) async throws -> QuestTipDataEntity {
        let tip = try await network.request(
            QuestAPI.tip(questID: questID),
            decodingType: QuestTipResponseDTO.self
        )
        return tip.toEntity()
    }
    
    func postActiveQuest(questID: Int, answer: String, emotionState: String, image: Data, imageKey: String) async throws {
        let url = try await makeSignedURL(imageKey: imageKey)
        
        try await putImage(signedURL: url, image: image)
        try await saveQuest(questID: questID, answer: answer, emotionState: emotionState, imageKey: imageKey)
    }
    
    func postQuestionQuest(questID: Int, answer: String, emotionState: String) async throws {
        let saveQuestRequestDTO: SaveQuestRequestDTO = .init(answer: answer, questEmotionState: emotionState)
        
        let _ = try await network.request(
            QuestAPI.recording(questID: questID, request: saveQuestRequestDTO)
        )
    }
    
    func getLookBackJourney() async throws -> [JourneyEntity] {
        let result = try await network.request(
            QuestAPI.fetchCompletedJourney,
            decodingType: LookBackJourneyResponseDTO.self
        )
        
        let entity = result.toEntity()
        return entity.completedJourneys
    }
    
    func getNewJourney() async throws -> LookBackJourneyEntity {
        let result = try await network.request(
            QuestAPI.fetchCompletedJourney,
            decodingType: LookBackJourneyResponseDTO.self
        )
        
        return result.toEntity()
    }
    
    func postNewJourney(journey: JourneyType) async throws {
        ByeBooLogger.debug(journey)
        // TODO: 로그인 붙인 후 주석 해제
        let _ = try await network.request(
            QuestAPI.postJourney(journey: journey)
        )
    }
    
    func fetchCompletedQuests(journey: JourneyType) async throws -> CompletedQuestsEntity {
        let result = try await network.request(
            QuestAPI.completedQuests(journey: journey),
            decodingType: CompletedQuestsResponseDTO.self
        )
        return result.toEntity()
    }
    
    func editQuestionQuest(questID: Int, answer: String) async throws {
        let editQuestRequestDTO: EditQuestRequestDTO = .init(answer: answer)
        
        let _ = try await network.request(
            QuestAPI.editRecording(questID: questID, request: editQuestRequestDTO)
        )
    }
    
    func editActiveQuest(questID: Int, answer: String, image: Data?, imageKey: String, isImageChanged: Bool) async throws {
        if isImageChanged {
            guard let image else { return }
            let url = try await makeSignedURL(imageKey: imageKey)
            try await putImage(signedURL: url, image: image)
        }
        try await editQuest(questID: questID, answer: answer, imageKey: imageKey)
    }
    
    // MARK: private function
    
    private func makeSignedURL(imageKey: String) async throws -> String {
        let signedURLRequestDTO = SignedURLRequestDTO(contentType: "image/jpeg", imageKey: imageKey)
        ByeBooLogger.debug(imageKey)
        let result = try await network.request(
            QuestAPI.images(request: signedURLRequestDTO),
            decodingType: SignedURLResponseDTO.self
        )
        
        return result.signedUrl
    }
    
    private func putImage(signedURL: String, image: Data) async throws {
        try await network.request(image: image, signedURL: signedURL)
    }
    
    private func saveQuest(
        questID: Int,
        answer: String,
        emotionState: String,
        imageKey: String
    ) async throws {
        let saveQuestActiveDTO = SaveQuestActiveRequestDTO(
            imageKey: imageKey,
            answer: answer,
            questEmotionState: emotionState
        )
        
        let _ = try await network.request(
            QuestAPI.active(questID: questID, request: saveQuestActiveDTO)
        )
    }
    
    private func editQuest(
        questID: Int,
        answer: String,
        imageKey: String
    ) async throws {
        let editQuestActiveDTO = EditQuestActiveRequestDTO(
            imageKey: imageKey,
            answer: answer
        )
        
        let _ = try await network.request(
            QuestAPI.editActive(questID: questID, request: editQuestActiveDTO)
        )
    }
}

final class MockQuestsRepository: QuestsInterface {
    
    private(set) var postActiveQuestCalled = false
    private(set) var postQuestionQuestCalled = false
    private(set) var postNewJourneyCalled = false
    private(set) var editQuestionQuestCalled = false
    private(set) var editActiveQuestCalled = false
    
    func fetchProgressingQuests() async throws -> ProgressingQuestsEntity {
        return .stub()
    }
    
    func getQuestInfo(questID: Int) async throws -> QuestInfoEntity {
        return .stub()
    }
    
    func fetchQuestAnswer(questID: Int) async throws -> QuestAnswerEntity {
        return .stub()
    }
    
    func fetchQuestTips(questID: Int) async throws -> QuestTipDataEntity {
        return .stub()
    }
    
    func postActiveQuest(questID: Int, answer: String, emotionState: String, image: Data, imageKey: String) async throws {
        self.postActiveQuestCalled = true
    }
    
    func postQuestionQuest(questID: Int, answer: String, emotionState: String) async throws {
        self.postQuestionQuestCalled = true
    }
    
    func getLookBackJourney() async throws -> [JourneyEntity]{
        return [JourneyEntity.stub()]
    }
    
    func getNewJourney() async throws -> LookBackJourneyEntity {
        return .stub()
    }
    
    func postNewJourney(journey: JourneyType) async throws {
        self.postNewJourneyCalled = true
    }
    
    func fetchCompletedQuests(journey: JourneyType) async throws -> CompletedQuestsEntity {
        return .stub()
    }
    
    func editQuestionQuest(questID: Int, answer: String) async throws {
        self.editQuestionQuestCalled = true
    }
    
    func editActiveQuest(questID: Int, answer: String, image: Data?, imageKey: String, isImageChanged: Bool) async throws {
        self.editActiveQuestCalled = true
    }
    
    func fetchCommoncQuest(date: String) async throws -> CommonQuestAnswersEntity {
        .stub()
    }
}
