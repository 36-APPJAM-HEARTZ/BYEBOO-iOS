//
//  FetchCompletedQuestsUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 9/1/25.
//

protocol FetchCompletedQuestsUseCase {
    func execute(journey: JourneyType) async throws -> CompletedQuestsEntity
}

struct DefaultFetchCompletedQuestsUseCase: FetchCompletedQuestsUseCase {
    
    private let repository: QuestsInterface
    
    init(repository: QuestsInterface) {
        self.repository = repository
    }
    
    func execute(journey: JourneyType) async throws -> CompletedQuestsEntity {
        return try await repository.fetchCompletedQuests(journey: journey)
    }
}
