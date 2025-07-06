//
//  SceneDelegate.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/23/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        DIContainer.shared.dependencyInject()
        guard let testViewModel = DIContainer.shared.resolve(type: TestViewModel.self) else {
            ByeBooLogger.error(ByeBooError.DIFailedError)
            fatalError()
        }
//        let testViewController = TestViewController(viewModel: testViewModel)
        
        let viewController = BottomNavigationViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
    
}

