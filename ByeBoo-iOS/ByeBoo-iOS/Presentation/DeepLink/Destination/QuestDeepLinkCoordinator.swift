//
//  QuestDeepLinkCoordinator.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/18/26.
//

import UIKit

struct QuestDeepLinkCoordinator: DeepLinkCoordinator {
    private let questIndex = 1
    let questNumber: Int
    
    func navigate(from window: UIWindow) {
        let tabBarController = ViewControllerFactory.shared.makeByeBooTabBar()
        tabBarController.selectedIndex = questIndex
        
        guard let questCheckViewController = findQuestCheckViewController(from: tabBarController) else {
            return
        }
        
        questCheckViewController.pendingQuestNumber = questNumber
        
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: tabBarController,
            withAnimation: false
        )
    }
    
    private func findQuestCheckViewController(from tabBarController: ByeBooTabBar) -> QuestCheckViewController? {
        guard let navigationController = findNavigationController(from: tabBarController),
              let parentQuestViewController = findParentQuestViewController(from: navigationController),
              let questCheckViewController = findQuestCheckViewController(from: parentQuestViewController)
        else {
            return nil
        }
        
        selectParentQuestTab(for: parentQuestViewController, target: questCheckViewController)
        
        return questCheckViewController
    }
}

private extension QuestDeepLinkCoordinator {
    
    func findNavigationController(from tabBarController: ByeBooTabBar) -> UINavigationController? {
        tabBarController.viewControllers?[1] as? UINavigationController
    }
    
    func findParentQuestViewController(from navigationController: UINavigationController) -> ParentQuestViewController<QuestTabItem>? {
        navigationController.viewControllers.first as? ParentQuestViewController<QuestTabItem>
    }
    
    func findQuestCheckViewController(from parentQuestViewController: ParentQuestViewController<QuestTabItem>) -> QuestCheckViewController? {
        parentQuestViewController.controllers.first(where: { $0 is QuestCheckViewController }) as? QuestCheckViewController
    }
    
    func selectParentQuestTab(
        for parentQuestVC: ParentQuestViewController<QuestTabItem>,
        target questCheckVC: QuestCheckViewController
    ) {
        if let targetIndex = parentQuestVC.controllers.firstIndex(of: questCheckVC) {
            parentQuestVC.selectTab(index: targetIndex)
        }
    }
}
