//
//  CommonQuestInterface.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/1/26.
//

import Foundation

protocol CommonQuestInterface {
    func saveCommonQuest(questID: Int, answer: String) async throws
}
