//
//  DeepLinkCoordinator.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/11/26.
//

import UIKit

struct DeepLinkCoordinator {
    
    private weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController?) {
        self.rootViewController = rootViewController
    }
    
    func navigate(to destination: DeepLinkDestination) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            destination.navigate(from: window)
        }
    }
}
