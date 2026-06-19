//
//  CommonQuestAnswerDeepLinkCoordinator.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/18/26.
//

import UIKit

struct CommonQuestAnswerDeepLinkCoordinator: DeepLinkCoordinator {
    let answerID: Int
    
    func navigate(from window: UIWindow) {
        guard let tabBarController = window.rootViewController as? ByeBooTabBar else {
            return
        }
        
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: tabBarController,
            withAnimation: false
        )
        pushToHistory(from: tabBarController)
    }
}

private extension CommonQuestAnswerDeepLinkCoordinator {
    
    func pushToHistory(from tabBarController: ByeBooTabBar) {
        tabBarController.selectedIndex = 1
        
        guard let navigationController = findNavigationController(from: tabBarController) else {
            return
        }
        
        let historyViewController = ViewControllerFactory.shared.makeCommonQuestHistoryViewController()
        historyViewController.configure(answerID: answerID)
        
        navigationController.pushViewController(historyViewController, animated: true)
    }
    
    func findNavigationController(from tabBarController: ByeBooTabBar) -> UINavigationController? {
        tabBarController.viewControllers?[1] as? UINavigationController
    }
}
