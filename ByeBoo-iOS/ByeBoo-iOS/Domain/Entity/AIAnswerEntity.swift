//
//  AIAnswerEntity.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 3/4/26.
//

struct AIAnswerEntity {
    let AIAnswer: String
}

extension AIAnswerEntity {
    static func stub() -> Self {
        return .init(AIAnswer: "어 나 AI인데 힘내라")
    }
}
