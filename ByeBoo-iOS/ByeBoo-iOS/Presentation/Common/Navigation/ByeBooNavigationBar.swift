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

struct ByeBooNavigationBar {
    
    static func makeNavigationBar(
        navigationItem: UINavigationItem,
        navigationController: UINavigationController?,
        type: NavigationBarType,
        action: Selector? = nil
    ) {
        
        let barAppearance = makeBasicBarAppearance()
        
        guard let topViewController = navigationController?.topViewController as? BaseViewController else {
            return
        }
        
        configureNavigationItem(
            navigationItem: navigationItem,
            topViewController: topViewController,
            type: type,
            action: action
        )
        
        registerBarAppearance(barAppearance, to: navigationController)
    }
    
    private static func makeBasicBarAppearance() -> UINavigationBarAppearance {
        let barAppearance = UINavigationBarAppearance()
        barAppearance.do {
            $0.configureWithTransparentBackground()
            $0.titleTextAttributes = [
                .font: FontManager.sub1Sb20.font,
                .foregroundColor: UIColor.white
            ]
        }
        return barAppearance
    }
    
    private static func configureNavigationItem(
        navigationItem: UINavigationItem,
        topViewController: BaseViewController,
        type: NavigationBarType,
        action: Selector?
    ) {
        switch type {
        case .back:
            let backButtonItem = makeBarButtonItem(
                image: .left.withTintColor(.white),
                target: topViewController,
                action: action
            )
            navigationItem.leftBarButtonItem = backButtonItem
            
        case .title(let string):
            navigationItem.title = string
            
        case .close:
            makeCloseButtonItem(
                image: .xicon,
                target: topViewController,
                navigationItem: navigationItem,
                action: action
            )
            
        case .titleAndClose(let string):
            makeCloseButtonItem(
                image: .xicon,
                target: topViewController,
                navigationItem: navigationItem,
                action: action
            )
            navigationItem.title = string
        }
    }
    
    private static func registerBarAppearance(
        _ barAppearance: UINavigationBarAppearance,
        to navigationController: UINavigationController?
    ) {
        navigationController?.navigationBar.do {
            $0.standardAppearance = barAppearance
            $0.scrollEdgeAppearance = barAppearance
        }
    }
    
    private static func makeBarButtonItem(
        image: UIImage,
        target: BaseViewController,
        action: Selector?
    ) -> UIBarButtonItem {
        return UIBarButtonItem(
            image: image.withTintColor(.white).withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: target,
            action: action
        )
    }
    
    private static func makeCloseButtonItem(
        image: UIImage,
        target: BaseViewController,
        navigationItem: UINavigationItem,
        action: Selector?
    ) {
        let closeButtonItem = makeBarButtonItem(image: image, target: target, action: action)
        navigationItem.rightBarButtonItem = closeButtonItem
    }
}
