//
//  SaveQuestDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Foundation

struct SaveQuestRequestDTO: Encodable {
    var answer: String
    var questEmotionState: String
}
