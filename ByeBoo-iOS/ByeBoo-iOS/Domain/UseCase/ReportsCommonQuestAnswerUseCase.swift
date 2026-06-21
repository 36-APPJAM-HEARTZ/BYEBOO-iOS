//
//  ReposrtCommonQuestAnswerUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/5/26.
//

import Foundation

protocol ReportsCommonQuestAnswerUseCase {
    func execute(targetID: Int, targetType: CommonQuestTargetType) async throws
}

struct DefaultReportsCommonQuestAnswerUseCase: ReportsCommonQuestAnswerUseCase {
    
    private let repository: ReportsInterface
    
    init(
        repository: ReportsInterface
    ) {
        self.repository = repository
    }
    
    func execute(targetID: Int, targetType: CommonQuestTargetType) async throws {
        let _ = try await repository.reportCommonQuest(targetID: targetID, targetType: targetType)
    }
}
