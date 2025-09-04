//
//  ViewControllerUtils.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/13/25.
//

import UIKit

struct ViewControllerUtils {
    static func setRootViewController(window: UIWindow, viewController: UIViewController, withAnimation: Bool) {
        if !withAnimation {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            return
        }
        
        if let snapshot = window.snapshotView(afterScreenUpdates: true) {
            viewController.view.addSubview(snapshot)
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
            UIView.animate(withDuration: 0.4, animations: {
                snapshot.layer.opacity = 0
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
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
}
