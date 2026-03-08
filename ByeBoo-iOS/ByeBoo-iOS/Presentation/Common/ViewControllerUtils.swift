//
//  ViewControllerUtils.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/13/25.
//

import UIKit

struct ViewControllerUtils {
    static func setRootViewController(
        window: UIWindow,
        viewController: UIViewController,
        withAnimation: Bool,
        completion: (() -> Void)? = nil) {
        if !withAnimation {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            completion?() 
            return
        }
        
        DispatchQueue.main.async{
            if let snapshot = window.snapshotView(afterScreenUpdates: true) {
                viewController.view.addSubview(snapshot)
                window.rootViewController = viewController
                window.makeKeyAndVisible()
                
                UIView.animate(withDuration: 0.4, animations: {
                    snapshot.layer.opacity = 0
                }, completion: { _ in
                    snapshot.removeFromSuperview()
                    completion?()
                })
            }
        }
    }
    
    static func changeSelectedIndex(index: Int) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }),
           let tabBarController = window.rootViewController as? UITabBarController {
            guard tabBarController.viewControllers?[safe: index] != nil else { return }
            tabBarController.selectedIndex = index
        }
    }
    
    static func changeQuestTabWithIndex(index: Int, completion: (() -> Void)? = nil) {
        let viewController = ByeBooTabBar()
        viewController.selectedIndex = 1
        guard let questMaintab = viewController.viewControllers?[1] as? UINavigationController,
              let commonQuestTab = questMaintab.viewControllers.first as? ParentQuestViewController<QuestTabItem> else {
            return }
        
        commonQuestTab.loadViewIfNeeded()
        commonQuestTab.selectTab(index: index)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            ByeBooLogger.debug("setRootViewController 호출 전")
            ViewControllerUtils.setRootViewController(
                window: window,
                viewController: viewController,
                withAnimation: true,
                completion: {
                    ByeBooLogger.debug("completion 호출됨")
                    completion?()
                }
            )
        }
    }
}
