//
//  CommonQuestRepository.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/1/26.
//

import Foundation

struct DefaultCommonQuestRepository: CommonQuestInterface {
    private let network: NetworkService
    
    init(
        network: NetworkService
    ) {
        self.network = network
    }
    
    func saveCommonQuest(questID: Int, answer: String) async throws {
        let saveCommonQuestRequestDTO: SaveCommonQuestRequestDTO = .init(answer: answer)
        
        let _ = try await network.request(
            CommonQuestAPI.postCommonQuest(questID: questID, dto: saveCommonQuestRequestDTO)
        )
    }
}
