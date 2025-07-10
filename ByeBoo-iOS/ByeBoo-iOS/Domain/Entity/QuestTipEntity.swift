//
//  QuestTipEntity.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import Foundation

struct QuestTipDataEntity {
    let step: String
    let stepNumber: Int
    let questNumber: Int
    let question: String
    let tips: [QuestTipEntity]
}

struct QuestTipEntity {
    let tipStep: Int
    let tipQuestion: String
    let tipAnswer: String
}
