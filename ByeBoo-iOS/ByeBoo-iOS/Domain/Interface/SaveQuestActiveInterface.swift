//
//  SaveQuestActiveInterface.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/14/25.
//

import Foundation

protocol SaveQuestActiveInterface {
    func postActiveQuest(
        questID: Int,
        answer: String,
        emotionState: String,
        image: Data,
        imageKey: String) async throws
}
