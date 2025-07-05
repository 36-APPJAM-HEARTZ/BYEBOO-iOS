//
//  BottomNavigationViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/5/25.
//

import UIKit

final class BottomNavigationViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        setViewControllerAppearance()
    }
    
    private func setViewController() {
        viewControllers = [
            createViewController(for: HomeViewController(), title: "홈", imageName: .homeOff),
            createViewController(for: QuestViewController(), title: "퀘스트", imageName: .questOff),
            createViewController(for: MyPageViewController(), title: "내 정보", imageName: .userOff)
        ]
    }
    
    private func setViewControllerAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .black50
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = .grayscale400
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.grayscale400,
            .font: FontManager.body5R14.font
        ]
        
        itemAppearance.selected.iconColor = .primary300
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.primary300,
            .font: FontManager.body5R14.font
        ]
        
        appearance.stackedLayoutAppearance = itemAppearance
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func createViewController(for rootViewController: UIViewController,
                                      title: String,
                                      imageName: UIImage) -> UIViewController {
        let viewController = UINavigationController(rootViewController: rootViewController)
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = imageName.withRenderingMode(.alwaysTemplate)
        return viewController
    }
}
