//
//  GetProgressingQuestsUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/14/25.
//

protocol GetProgressingQuestsUseCase {
    func execute(userID: Int) async throws -> ProgressingQuestsEntity
}

struct DefaultGetProgressingQuestsUseCase: GetProgressingQuestsUseCase {
    
    private let repository: QuestsInterface
    
    init(repository: QuestsInterface) {
        self.repository = repository
    }
    
    func execute(userID: Int) async throws -> ProgressingQuestsEntity {
        return try await repository.fetchProgressingQuests(userID: userID)
    }
}
//
//final class MockGetProgressingQuestsUseCase: GetProgressingQuestsUseCase {
//    
//    private var called: Int = 0
//    
//    func execute(userID: Int) async throws -> ProgressingQuestsEntity {
//        if called == 0 {
//            called += 1
//            throw ByeBooError.beforeJourney
//        }
//        return .stub()
//    }
//}
