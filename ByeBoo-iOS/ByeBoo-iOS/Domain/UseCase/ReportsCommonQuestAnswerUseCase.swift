//
//  ReposrtCommonQuestAnswerUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/5/26.
//

import Foundation

protocol ReportsCommonQuestAnswerUseCase {
    func execute(answerID: Int) async throws
}

struct DefaultReportsCommonQuestAnswerUseCase: ReportsCommonQuestAnswerUseCase {
    
    private let repository: ReportsInterface
    
    init(
        repository: ReportsInterface
    ) {
        self.repository = repository
    }
    
    func execute(answerID: Int) async throws {
        let _ = try await repository.reportCommonQuest(answerID: answerID)
    }
}
