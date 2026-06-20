//
//  DeepLinkCoordinator.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/17/26.
//

import UIKit

protocol DeepLinkCoordinator {
    func navigate(from window: UIWindow)
    func findNavigationController(from tabBarController: ByeBooTabBar, index: Int) -> UINavigationController?
}

extension DeepLinkCoordinator {
    func findNavigationController(from tabBarController: ByeBooTabBar, index: Int) -> UINavigationController? {
        guard let controllers = tabBarController.viewControllers,
              controllers.indices.contains(index)
        else {
            return nil
        }
        
        return tabBarController.viewControllers?[index] as? UINavigationController
    }
}
