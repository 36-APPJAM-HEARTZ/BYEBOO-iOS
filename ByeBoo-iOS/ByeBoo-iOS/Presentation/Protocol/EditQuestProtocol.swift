//
//  EditQuestProtocol.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 11/11/25.
//

protocol EditQuestProtocol {
    var questMode: QuestMode { get set }
    func getExistingQuest(questID: Int, questAnswer: String?, image: String?, imageKey: String?)
}
