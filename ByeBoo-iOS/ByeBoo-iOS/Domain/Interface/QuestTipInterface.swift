//
//  QuestTipInterface.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

protocol QuestTipInterface {
    func fetchQeustTips() async throws -> QuestTipDataEntity
}
