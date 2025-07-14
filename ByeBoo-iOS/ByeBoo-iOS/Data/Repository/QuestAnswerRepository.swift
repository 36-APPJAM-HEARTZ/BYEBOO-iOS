//
//  QuestAnswerRepository.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/14/25.
//

import Foundation

struct DefaultQuestAnswerRepository: QuestAnswerInterface {
    private let network: NetworkService
    private let userDefaultService: UserDefaultService
    
    init(
        network: NetworkService,
        userDefaultService: UserDefaultService
    ) {
        self.network = network
        self.userDefaultService = userDefaultService
    }
    
    func execute(questID: Int) async throws -> QuestAnswerEntity {
        let userID: Int = userDefaultService.load(key: .userID) ?? 1
        let result = try await network.request(
            QuestAPI.answer(userID: userID, questID: questID),
            decodingType: QuestAnswerResponseDTO.self
        )
        return result.toEntity()
    }
}
