//
//  FetchUserJourneyUseCase.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

protocol FetchUserJourneyUseCase {
    func execute() async throws -> JourneyEntity
}

struct DefaultFetchUserJourneyUseCase: FetchUserJourneyUseCase {
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> JourneyEntity {
        return try await repository.getJourney()
    }
}

struct MockFetchUserJourneyUseCase: FetchUserJourneyUseCase {
    func execute() async throws -> JourneyEntity {
        return .stub()
    }
}
