//
//  QuestsDTO.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import Foundation

struct QuestsDTO: Decodable {
    let progressPeriod: String
    let currentStep: Int
    let isCompleted: Bool
    let steps: [StepDTO]
}

struct StepDTO: Decodable {
    let stepNumber: Int
    let step: String
    let quests: [QuestDTO]
}

struct QuestDTO: Decodable {
    let questId: Int
    let questNumber: Int
}

// 추후 toEntity 추가
