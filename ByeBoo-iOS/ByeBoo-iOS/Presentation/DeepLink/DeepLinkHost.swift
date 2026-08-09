//
//  DeepLinkHost.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/17/26.
//

enum DeepLinkHost: String {
    case quest = "quest"
    case commonQuest = "common-quests"
    
    func destination(id: Int) -> DeepLinkCoordinator {
        switch self {
        case .quest:
            MyJourneyDeepLinkCoordinator(questNumber: id)
        case .commonQuest:
            CommonQuestAnswerDeepLinkCoordinator(answerID: id)
        }
    }
}
