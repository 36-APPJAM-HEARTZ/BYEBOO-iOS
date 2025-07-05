//
//  ByeBooNavigationbar.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/5/25.
//

import UIKit

import SnapKit

enum NavigationBarType {
    case back
    case title(String)
    case close
    case titleAndClose(String)
}

final class ByeBooNavigationBar {
    
    static func makeNavigationBar(
        navigationItem: UINavigationItem,
        navigationController: UINavigationController?,
        type: NavigationBarType
    ) -> UINavigationBarAppearance {
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.do {
            $0.backgroundColor = .black
            $0.shadowColor = .clear
            $0.titleTextAttributes = [
                .font: FontManager.sub1Sb20.font,
                .foregroundColor: UIColor.white
            ]
        }
        
        switch type {
        case .back:
            let backButtonItem = makeBarButtonItem(
                image: .left.withTintColor(.white),
                target: navigationController?.topViewController
            )
            navigationItem.leftBarButtonItem = backButtonItem
            
        case .title(let string):
            navigationItem.title = string
            
        case .close:
            makeCloseButtonItem(
                image: .xicon,
                target: navigationController?.topViewController,
                navigationItem: navigationItem
            )
            
        case .titleAndClose(let string):
            makeCloseButtonItem(
                image: .xicon,
                target: navigationController?.topViewController,
                navigationItem: navigationItem
            )
            navigationItem.title = string
        }
        
        navigationController?.navigationBar.do {
            $0.standardAppearance = barAppearance
            $0.scrollEdgeAppearance = barAppearance
        }
        
        return barAppearance
    }
    
    private static func makeBarButtonItem(image: UIImage, target: UIViewController?) -> UIBarButtonItem {
        return UIBarButtonItem(
            image: image.withTintColor(.white).withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: target,
            action: nil
        )
    }
    
    private static func makeCloseButtonItem(
        image: UIImage,
        target: UIViewController?,
        navigationItem: UINavigationItem
    ) {
        let closeButtonItem = makeBarButtonItem(image: image, target: target)
        navigationItem.rightBarButtonItem = closeButtonItem
    }
}
