//
//  SaveQuestTypeRepository.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Foundation

struct DefaultSaveQuestTypeRepository: SaveQuestTypeInterface {
    private let network: NetworkService
    private let userDefaultService: UserDefaultService
    
    init(
        network: NetworkService,
        userDefaultService: UserDefaultService
    ) {
        self.network = network
        self.userDefaultService = userDefaultService
    }
    
    func postSaveQuest(questID: Int) async throws -> Void {
        let userID: Int = userDefaultService.load(key: .userID) ?? 1
        let result = try await network.request(
            QuestAPI.recording(userID: userID, questID: questID),
            decodingType: BaseResponse<EmptyResponse>.self
        )
    }
}
