//
//  GetProgressingQuestsRepository.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/14/25.
//

import Foundation

struct DefaultGetProgressingQuestsRepository: GetProgressingQuestsInterface {
    
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
            QuestAPI.progressingQuests(userID: userID),
            decodingType: ProgressingQuestsResponseDTO.self
        )
        return result.toEntity()
    }
}
