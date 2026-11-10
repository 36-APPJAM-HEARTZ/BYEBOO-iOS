//
//  BottomNavigationViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/5/25.
//

import UIKit

final class ByeBooTabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .grayscale900

        if #unavailable(iOS 26) {
            setValue(ByeBooTabBarView(), forKey: "tabBar")
        }
        setViewController()
        setViewControllerAppearance()
    }
    
    
    private func setViewController() {
        
        let homeViewController = ViewControllerFactory.shared.makeHomeViewController()
        let questViewController = ViewControllerFactory.shared.makeParentQuestViewController()
        let myPageViewController = ViewControllerFactory.shared.makeMyPageViewController()
        
        self.viewControllers = [
            createViewController(
                for: homeViewController,
                title: "홈",
                imageName: .homeOff
            ),
            createViewController(
                for: questViewController,
                title: "퀘스트",
                imageName: .questOff,
                container: questViewController.embeddedInListDetail()
            ),
            createViewController(
                for: myPageViewController,
                title: "내 정보",
                imageName: .userOff,
                container: myPageViewController.embeddedInListDetail()
            )
        ]
    }
    
    private func setViewControllerAppearance() {
        let appearance = UITabBarAppearance()
        let titleOffset: UIOffset

        if #available(iOS 26, *) {
            appearance.configureWithDefaultBackground()
            titleOffset = UIOffset(horizontal: 0, vertical: 4.adjustedH)
        } else {
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .grayscale900
            appearance.shadowColor = .grayscale800
            titleOffset = UIOffset(horizontal: 0, vertical: -4.adjustedH)
        }

        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = .grayscale400
        itemAppearance.normal.titlePositionAdjustment = titleOffset
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.grayscale400,
            .font: FontManager.body6R14.font
        ]
        
        itemAppearance.selected.iconColor = .primary300
        itemAppearance.selected.titlePositionAdjustment = titleOffset
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.primary300,
            .font: FontManager.body6R14.font
        ]
        
        appearance.stackedLayoutAppearance = itemAppearance
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func createViewController(for rootViewController: UIViewController,
                                      title: String,
                                      imageName: UIImage,
                                      container: UIViewController? = nil) -> UIViewController {
        let viewController = container ?? ByeBooNavigationController(rootViewController: rootViewController)
        rootViewController.tabBarItem.title = title
        rootViewController.tabBarItem.image = imageName.withRenderingMode(.alwaysTemplate)
        viewController.tabBarItem = rootViewController.tabBarItem
        return viewController
    }
}
