//
//  GetLookBackJourneyUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/20/25.
//

protocol GetLookBackJourneyUseCase {
    func execute() async throws -> [JourneyEntity]
}

struct DefaultGetLookBackJourneyUseCase: GetLookBackJourneyUseCase {
    
    private let lookBackJourneyRepository: QuestsInterface
    
    init(lookBackJourneyRepository: QuestsInterface) {
        self.lookBackJourneyRepository = lookBackJourneyRepository
    }
    
    func execute() async throws -> [JourneyEntity] {
        try await lookBackJourneyRepository.getLookBackJourney()
    }
}

