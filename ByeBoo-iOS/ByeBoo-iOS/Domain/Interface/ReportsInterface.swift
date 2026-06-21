//
//  ReportsInterface.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/5/26.
//

protocol ReportsInterface {
    func reportCommonQuest(targetID: Int, targetType: CommonQuestTargetType) async throws
}
