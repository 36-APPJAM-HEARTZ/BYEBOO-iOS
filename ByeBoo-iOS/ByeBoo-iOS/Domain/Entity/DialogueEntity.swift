//
//  DialogueEntity.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 11/19/25.
//

import Foundation

struct DialogueEntity {
    let dialogue: String
    let tapDialogue: String
}

extension DialogueEntity {
    static func stub() -> Self {
        return .init(
            dialogue: "천천히, 하지만 분명하게 나아갈 거에요",
            tapDialogue: "앗! 저를 부르셨나요?"
        )
    }
}
