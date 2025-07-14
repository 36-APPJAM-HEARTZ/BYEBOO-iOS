//
//  QuestTipRepository.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import Foundation

struct DefaultQuestTipRepository: QuestTipInterface {
    
    private let network: NetworkService
    private let userDefaultService: UserDefaultService
    
    init(
        network: NetworkService,
        userDefaultService: UserDefaultService
    ) {
        self.network = network
        self.userDefaultService = userDefaultService
    }
    
    func fetchQeustTips(questID: Int) async throws -> QuestTipDataEntity {
        let userID: Int = userDefaultService.load(key: .userID) ?? 1
        
        let tip = try await network.request(
            QuestAPI.tip(userID: userID, questID: questID),
            decodingType: QuestTipResponseDTO.self
        )
        return tip.toEntity()
    }
    
}
