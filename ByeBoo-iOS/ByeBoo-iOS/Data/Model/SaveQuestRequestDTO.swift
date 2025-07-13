//
//  SaveQuestDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Foundation

struct SaveQuestRequestDTO: Encodable {
    var questId: Int
    var isComplete: Bool
}
