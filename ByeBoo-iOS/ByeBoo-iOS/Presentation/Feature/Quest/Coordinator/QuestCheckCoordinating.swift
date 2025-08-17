//
//  QuestCheckCoordinating.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/9/25.
//

protocol QuestCheckCoordinating {
    
    func moveQuestStart()
    func moveArchive(quest: QuestEntity?)
    func presentQuestModal(quest: QuestEntity?)
    func moveQuestTip(quest: QuestEntity?)
    func moveWriteQuest(quest: QuestEntity)
}
