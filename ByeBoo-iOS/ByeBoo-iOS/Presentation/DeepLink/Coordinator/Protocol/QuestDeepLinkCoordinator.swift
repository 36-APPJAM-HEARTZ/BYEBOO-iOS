//
//  QuestDeepLinkCoordinator.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/20/26.
//

import UIKit

protocol QuestDeepLinkCoordinator: DeepLinkCoordinator {
    
    typealias QuestHostVC = ParentQuestViewController<QuestTabItem>
    
    var questViewIndex: Int { get }
    func selectedQuestTab<T>(from navigationController: UINavigationController) -> T?
}

extension QuestDeepLinkCoordinator {
    
    var questViewIndex: Int { 1 }
    
    func selectedQuestTab<T>(
        from navigationController: UINavigationController
    ) -> T? {
        guard let questHostVC = navigationController.viewControllers.first as? QuestHostVC,
              let targetVC: T = questHostVC.controllers.first(where: { $0 is T }) as? T
        else {
            return nil
        }
        
        selectQuestTab(for: questHostVC, target: targetVC)
        
        return targetVC
    }
}

private extension QuestDeepLinkCoordinator {
    
    func selectQuestTab<T>(
        for questHostVC: QuestHostVC,
        target targetVC: T
    ) {
        if let targetIndex = questHostVC.controllers.firstIndex(of: targetVC as! UIViewController) {
            questHostVC.selectTab(index: targetIndex)
        }
    }
}
