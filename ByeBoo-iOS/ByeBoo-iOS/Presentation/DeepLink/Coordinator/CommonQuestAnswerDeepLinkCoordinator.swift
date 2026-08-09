//
//  CommonQuestAnswerDeepLinkCoordinator.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/18/26.
//

import UIKit

struct CommonQuestAnswerDeepLinkCoordinator: QuestDeepLinkCoordinator {
    
    let answerID: Int
    
    init(answerID: Int) {
        self.answerID = answerID
    }
    
    func navigate(from window: UIWindow) {
        let tabBarController = ViewControllerFactory.shared.makeByeBooTabBar()
        tabBarController.selectedIndex = questViewIndex
        
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: tabBarController,
            withAnimation: false
        )
        
        guard let navigationController = findNavigationController(from: tabBarController, index: questViewIndex),
              let _: CommonQuestViewController = selectedQuestTab(from: navigationController)
        else {
            return
        }
        
        pushToHistory(from: navigationController)
    }
}

private extension CommonQuestAnswerDeepLinkCoordinator {
    
    func pushToHistory(from navigationController: UINavigationController) {
        let historyVC = ViewControllerFactory.shared.makeCommonQuestHistoryViewController()
        historyVC.configure(answerID: answerID)
        
        navigationController.pushViewController(historyVC, animated: false)
    }
}
