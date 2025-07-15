//
//  SaveQuestActiveRequestDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/14/25.
//

import Foundation

struct SaveQuestActiveRequestDTO: Encodable {
    var imageKey: String
    var answer: String
    var questEmotionState: String
}
