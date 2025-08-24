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
    let style: JourneyStyle?
}

extension JourneyEntity {
    static func stub() -> Self {
        return .init(title: "감정 직면", description: "설명", style: .recording)
    }
}
