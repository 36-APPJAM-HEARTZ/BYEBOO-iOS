//
//  QuestAnswerEntity.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import Foundation

struct QuestAnswerEntity {
    var stepNumber: Int
    var questNumber: Int
    var createdAt: String
    var question: String
    var answer: String?
    var questEmotionState: String
    var imageUrl: String?
    var emotionDescription: String
}
