//
//  SaveQuestActiveRepository.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/14/25.
//

import Foundation

import Alamofire

struct DefaultSaveActiveQuestRepository: SaveQuestActiveInterface{
    private let network: NetworkService
    private let userDefaultService: UserDefaultService
    
    init(
        network: NetworkService,
        userDefaultService: UserDefaultService
    ) {
        self.network = network
        self.userDefaultService = userDefaultService
    }
    
    func postActiveQuest(
        questID: Int,
        answer: String,
        emotionState: String,
        image: Data,
        imageKey: String
    ) async throws {
//        let userID: Int = userDefaultService.load(key: .userID) ?? 1

        let url = try await makeSignedURL(imageKey: imageKey)

        try await putImage(signedURL: url, image: image)
        try await saveQuest(questID: questID, answer: answer, emotionState: emotionState, imageKey: imageKey)
    }
    
    private func makeSignedURL(imageKey: String) async throws -> String {
        let userID: Int = userDefaultService.load(key: .userID) ?? 1
        let signedURLRequestDTO = SignedURLRequestDTO(contentType: "image/jpeg", imageKey: imageKey)
        
        let result = try await network.request(
            QuestAPI.images(userID: userID, request: signedURLRequestDTO),
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
        let userID: Int = userDefaultService.load(key: .userID) ?? 1
        let saveQuestActiveDTO = SaveQuestActiveRequestDTO(
            imageKey: imageKey,
            answer: answer,
            questEmotionState: emotionState
        )
        
        let _ = try await network.request(
            QuestAPI.active(userID: userID, questID: questID, request: saveQuestActiveDTO)
        )
    }
}
