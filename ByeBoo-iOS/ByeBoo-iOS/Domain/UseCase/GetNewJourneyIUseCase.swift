//
//  GetNewJourneyIUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/21/25.
//

protocol GetNewJourneyUseCase {
    func execute() async throws -> LookBackJourneyEntity
}

struct DefaultGetNewJourneyUseCase: GetNewJourneyUseCase {
    private let lookBackJourneyRepository: QuestsInterface
    
    init(lookBackJourneyRepository: QuestsInterface) {
        self.lookBackJourneyRepository = lookBackJourneyRepository
    }
    
    func execute() async throws -> LookBackJourneyEntity {
        try await lookBackJourneyRepository.getNewJourney()
    }
}
