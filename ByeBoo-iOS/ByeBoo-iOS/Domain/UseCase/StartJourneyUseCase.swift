//
//  StartJourneyUseCase.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/14/25.
//

import Foundation

protocol StartJourneyUseCase {
    func execute() async throws
}

struct DefaultStartJourneyUseCase: StartJourneyUseCase {
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.startJourney()
    }
}

struct MockStartJourneyUseCase: StartJourneyUseCase {
    func execute() async throws { }
}
