//
//  FetchNewJourneyUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/24/25.
//

protocol FetchNewJourneyUseCase {
    func execute(journey: JourneyType) async throws
}

struct DefaultFetchNewJourneyUseCase: FetchNewJourneyUseCase {
    private let fetchNewJourneyRepository: QuestsInterface
    
    init(fetchNewJourneyRepository: QuestsInterface) {
        self.fetchNewJourneyRepository = fetchNewJourneyRepository
    }
    
    func execute(journey: JourneyType) async throws {
        try await fetchNewJourneyRepository.postNewJourney(journey: journey)
    }
}
