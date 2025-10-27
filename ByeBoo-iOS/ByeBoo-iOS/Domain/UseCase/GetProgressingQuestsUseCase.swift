//
//  GetProgressingQuestsUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/14/25.
//

protocol GetProgressingQuestsUseCase {
    func execute() async throws -> ProgressingQuestsEntity
}

struct DefaultGetProgressingQuestsUseCase: GetProgressingQuestsUseCase {
    
    private let repository: QuestsInterface
    
    init(repository: QuestsInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> ProgressingQuestsEntity {
        return try await repository.fetchProgressingQuests()
    }
}

struct MockGetProgressingQuestsUseCase: GetProgressingQuestsUseCase {
    
    func execute() async throws -> ProgressingQuestsEntity {
        return .stub()
    }
}
