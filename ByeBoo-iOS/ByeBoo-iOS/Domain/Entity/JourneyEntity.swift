//
//  JourneyEntity.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

import Foundation

struct JourneyEntity {
    let title: String
    let description: String?
    let style: JourneyType?
    let questType: QuestType?
}

extension JourneyEntity: Equatable {
    static func stub() -> Self {
        return .init(title: "이별 극복", description: "설명", style: .recording, questType: .question)
    }
}
