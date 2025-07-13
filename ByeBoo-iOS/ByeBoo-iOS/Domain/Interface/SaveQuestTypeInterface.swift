//
//  SaveQuestTypeInterface.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Foundation

protocol SaveQuestTypeInterface {
    func postSaveQuest(questID: Int) async throws 
}
