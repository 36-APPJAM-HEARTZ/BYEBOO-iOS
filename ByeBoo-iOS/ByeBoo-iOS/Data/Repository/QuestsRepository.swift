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
    
    func fetchProgressingQuests(userID: Int) async throws -> ProgressingQuestsEntity {
        let result = try await network.request(
            QuestAPI.progressingQuests,
            decodingType: ProgressingQuestsResponseDTO.self
        )
        return result.toEntity()
    }
    
    func getQuestInfo(questID: Int) async throws -> QuestInfoEntity {
        let userID: Int = userDefaultsService.load(key: .userID) ?? 1
        let result = try await network.request(
            QuestAPI.checkQuest(questID: questID),
            decodingType: QuestInfoResponseDTO.self
        )
        return result.toEntity()
    }
    
    func fetchQuestAnswer(questID: Int) async throws -> QuestAnswerEntity {
        let userID: Int = userDefaultsService.load(key: .userID) ?? 1
        let result = try await network.request(
            QuestAPI.answer(questID: questID),
            decodingType: QuestAnswerResponseDTO.self
        )
        return result.toEntity()
    }
    
    func fetchQuestTips(questID: Int) async throws -> QuestTipDataEntity {
        let userID: Int = userDefaultsService.load(key: .userID) ?? 1
        
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
        let userID: Int = userDefaultsService.load(key: .userID) ?? 1
        let saveQuestRequestDTO: SaveQuestRequestDTO = .init(answer: answer, questEmotionState: emotionState)
        
        let _ = try await network.request(
            QuestAPI.recording(questID: questID, request: saveQuestRequestDTO)
        )
    }
    
    func getLookBackJourney() async throws -> [JourneyEntity] {
        let userID: Int = userDefaultsService.load(key: .userID) ?? 1
        let result = try await network.request(
            QuestAPI.journey,
            decodingType: LookBackJourneyResponseDTO.self
        )
        
        let entity = result.toEntity()
        return entity.completedJourneys
    }
    
    func getNewJourney() async throws -> LookBackJourneyEntity {
        let userID: Int = userDefaultsService.load(key: .userID) ?? 1
        let result = try await network.request(
            QuestAPI.journey,
            decodingType: LookBackJourneyResponseDTO.self
        )
        
        return result.toEntity()
    }
    
    func postNewJourney(journey: String) async throws {
        let journeyEnum = JourneyType.toEnum(journey)
        ByeBooLogger.debug(journeyEnum)
        // TODO: 로그인 붙인 후 주석 해제
//        let _ = try await network.request(
//            QuestAPI.postJourney(journey: journeyEnum)
//        )
    }
    
    // MARK: private function
    
    private func makeSignedURL(imageKey: String) async throws -> String {
        let userID: Int = userDefaultsService.load(key: .userID) ?? 1
        let signedURLRequestDTO = SignedURLRequestDTO(contentType: "image/jpeg", imageKey: imageKey)
        
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
        let userID: Int = userDefaultsService.load(key: .userID) ?? 1
        let saveQuestActiveDTO = SaveQuestActiveRequestDTO(
            imageKey: imageKey,
            answer: answer,
            questEmotionState: emotionState
        )
        
        let _ = try await network.request(
            QuestAPI.active(questID: questID, request: saveQuestActiveDTO)
        )
    }
}

struct MockQuestsRepository: QuestsInterface {
    func fetchProgressingQuests(userID: Int) async throws -> ProgressingQuestsEntity {
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
        
    }
    
    func postQuestionQuest(questID: Int, answer: String, emotionState: String) async throws {
        
    }
    
    func getLookBackJourney() async throws -> [JourneyEntity]{
        return [JourneyEntity.stub()]
    }
    
    func getNewJourney() async throws -> LookBackJourneyEntity {
        return .stub()
    }
    
    func postNewJourney(journey: String) async throws {
        
    }
}
