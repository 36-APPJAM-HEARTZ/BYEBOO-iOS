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
    
    func fetchProgressingQuests() async throws -> ProgressingQuestsEntity {
        let userID = userDefaultsService.load(key: .userID) ?? 1
        let result = try await network.request(
            QuestAPI.progressingQuests(userID: userID),
            decodingType: ProgressingQuestsResponseDTO.self
        )
        return result.toEntity()
    }
    
    func getUserID() -> Int? {
        return userDefaultsService.load(key: .userID)
    }
}
