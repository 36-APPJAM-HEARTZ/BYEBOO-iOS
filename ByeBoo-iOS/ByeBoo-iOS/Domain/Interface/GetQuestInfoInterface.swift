//
//  GetQuestInfoInterface.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Foundation

protocol GetQuestInfoInterface {
    func execute(questID: Int) async throws -> QuestInfoEntity
}
