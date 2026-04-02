//
//  QuestTabItem.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/12/26.
//

import UIKit

enum QuestTabItem: TabItem {
    
    case myJourney
    case commonJourney
    
    var title: String {
        switch self {
        case .myJourney:
            return "나의 여정"
        case .commonJourney:
            return "공통 여정"
        }
    }
    
    var image: UIImage {
        switch self {
        case .myJourney:
            return .myOn
        case .commonJourney:
            return .commonJourney
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .myJourney:
            return ViewControllerFactory.shared.makeQuestViewController()
        case .commonJourney:
            return ViewControllerFactory.shared.makeCommonQuestViewController()
        }
    }
}
