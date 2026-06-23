//
//  CommonQuestRepository.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/1/26.
//

import Foundation

struct DefaultCommonQuestRepository: CommonQuestInterface {
    
    private let network: NetworkService
    private let keychainService: KeychainService
    private let userDefaultsService: UserDefaultService
    
    init(
        network: NetworkService,
        keychainService: KeychainService,
        userDefaultService: UserDefaultService
    ) {
        self.network = network
        self.keychainService = keychainService
        self.userDefaultsService = userDefaultService
    }
    
    func saveCommonQuest(questID: Int, answer: String) async throws {
        let saveCommonQuestRequestDTO: SaveCommonQuestRequestDTO = .init(answer: answer)
        
        let _ = try await network.request(
            CommonQuestAPI.postCommonQuest(
                questID: questID,
                dto: saveCommonQuestRequestDTO
            )
        )
    }
    
    func fetchCommonQuest(
        date: String,
        cursor: Int?
    ) async throws -> CommonQuestAnswersEntity {
        let userID: Int = userDefaultsService.load(key: .userID) ?? 0
        let commonQuest = try await network.request(
            CommonQuestAPI.fetchCommonQuest(
                date: date,
                cursor: cursor
            ),
            decodingType: CommonQuestAnswersResponseDTO.self
        )
        return commonQuest.toEntity(userID: userID)
    }
    
    func updateCommonQuest(answerID: Int, answer: String) async throws {
        let requestDTO = UpdateCommonQuestRequestDTO(answer: answer)
        try await network.request(
            CommonQuestAPI.updateCommonQuest(
                answerID: answerID,
                dto: requestDTO
            )
        )
    }
    
    func deleteCommonQuest(answerID: Int) async throws {
        try await network.request(
            CommonQuestAPI.deleteCommonQuest(answerID: answerID)
        )
    }
    
    func fetchCommonQuestDetail(answerID: Int) async throws -> CommonQuestDetailEntity {
        let userID: Int = userDefaultsService.load(key: .userID) ?? 0
        let commonQuestDetail = try await network.request(
            CommonQuestAPI.fetchCommonQuestDetail(answerID: answerID),
            decodingType: CommonQuestAnswerDetailResponseDTO.self
        )
        
        return commonQuestDetail.toEntity(userID: userID)
    }
    
    func postCommonQuestLikes(answerID: Int) async throws -> CommonQuestLikeEntity {
        let response = try await network.request(
            CommonQuestAPI.postCommonQuestLike(answerID: answerID),
            decodingType: PostCommonQuestLikeResponseDTO.self
        )
        return response.toEntity()
    }
}
