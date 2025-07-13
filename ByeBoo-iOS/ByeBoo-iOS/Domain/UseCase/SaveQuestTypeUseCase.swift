//
//  SaveQuestTypeUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Foundation

protocol SaveQuestTypeUseCase {
    func execute(questID: Int, answer: String, emotionState: String) async throws
}

struct DefaultSaveQuestTypeUseCase: SaveQuestTypeUseCase {
    private let repqository: SaveQuestTypeInterface
    
    init(repqository: SaveQuestTypeInterface) {
        self.repqository = repqository
    }
    
    func execute(questID: Int, answer: String, emotionState: String) { }
}
