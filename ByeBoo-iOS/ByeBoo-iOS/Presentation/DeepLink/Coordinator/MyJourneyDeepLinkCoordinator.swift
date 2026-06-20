//
//  MyJourneyDeepLinkCoordinator.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/18/26.
//

import UIKit

struct MyJourneyDeepLinkCoordinator: QuestDeepLinkCoordinator {
    
    let questNumber: Int
    
    func navigate(from window: UIWindow) {
        let tabBarController = ViewControllerFactory.shared.makeByeBooTabBar()
        tabBarController.selectedIndex = questViewIndex
        
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: tabBarController,
            withAnimation: false
        )
        
        guard let navigationController = findNavigationController(from: tabBarController, index: questViewIndex),
              let questCheckVC: QuestCheckViewController = selectedQuestTab(from: navigationController)
        else {
            return
        }
        
        questCheckVC.setPendingQuestNumber(questNumber)
    }
}
