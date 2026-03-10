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
    
    init(
        network: NetworkService,
        keychainService: KeychainService
    ) {
        self.network = network
        self.keychainService = keychainService
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
        let commonQuest = try await network.request(
            CommonQuestAPI.fetchCommonQuest(
                date: date,
                cursor: cursor
            ),
            decodingType: CommonQuestAnswersResponseDTO.self
        )
        return commonQuest.toEntity()
    }
    
    func updateCommonQuest(answerID: Int, answer: String) async throws {
        let requestDTO = UpdateCommonQuestRequestDTO(answer: answer)
        try await network.request(
            CommonQuestAPI.updateCommonQuest(
                accessToken: loadAccessToken(),
                answerID: answerID,
                dto: requestDTO
            )
        )
    }
    
    private func loadAccessToken() -> String {
        keychainService.load(key: .accessToken)
    }
}
