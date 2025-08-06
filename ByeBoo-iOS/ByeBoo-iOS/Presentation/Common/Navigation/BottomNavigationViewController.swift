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
        
        view.backgroundColor = .grayscale900
        
        setViewController()
        setViewControllerAppearance()
    }
    
    private func setViewController() {
        
        guard let homeViewModel = DIContainer.shared.resolve(type: HomeViewModel.self),
              let myPageViewModel = DIContainer.shared.resolve(type: MyPageViewModel.self),
              let questViewModel = DIContainer.shared.resolve(type: QuestsViewModel.self)
        else {
            ByeBooLogger.error(ByeBooError.DIFailedError)
            
            //TODO: Login으로 변경
            let tempViewController = OnboardingViewController()
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                
                ViewControllerUtils.setRootViewController(
                    window: window,
                    viewController: tempViewController,
                    withAnimation: true
                )
            }
            
            return
        }
        
        self.viewControllers = [
            createViewController(for: HomeViewController(viewModel: homeViewModel), title: "홈", imageName: .homeOff),
            createViewController(for: QuestCheckViewController(viewModel: questViewModel), title: "퀘스트", imageName: .questOff),
            createViewController(for: MyPageViewController(viewModel: myPageViewModel), title: "내 정보", imageName: .userOff)
        ]
    }
    
    private func setViewControllerAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterialDark)
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
        rootViewController.tabBarItem.title = title
        rootViewController.tabBarItem.image = imageName.withRenderingMode(.alwaysTemplate)
        return viewController
    }
}
