//
//  QuestTipInterface.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

protocol QuestTipInterface {
    func fetchQuestTips(questID: Int) async throws -> QuestTipDataEntity
}
