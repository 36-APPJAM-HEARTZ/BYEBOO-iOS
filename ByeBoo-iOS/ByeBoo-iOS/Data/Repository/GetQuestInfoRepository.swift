//
//  GetQuestInfoRepository.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Foundation

struct DefaultGetQuestInfoRepository: GetQuestInfoInterface {
    private let network: NetworkService
    private let userDefaultService: UserDefaultService
    
    init(
        network: NetworkService,
        userDefaultService: UserDefaultService
    ) {
        self.network = network
        self.userDefaultService = userDefaultService
    }
    
    func execute(questID: Int) async throws -> QuestInfoEntity {
        let userID: Int = userDefaultService.load(key: .userID) ?? 1
        let result = try await network.request(
            QuestAPI.checkQuest(userID: 186, questID: 6),
            decodingType: QuestInfoResponseDTO.self
        )
        return result.toEntity()
    }
}

