//
//  ByeBooNavigationbar.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/5/25.
//

import UIKit

import SnapKit

enum NavigationHeaderType {
    case clear
    case black
}

enum NavigationBarType: Equatable {
    case back(header: NavigationHeaderType = .clear)
    case title(String, header: NavigationHeaderType = .clear)
    case close(header: NavigationHeaderType = .clear)
    case titleAndClose(String, header: NavigationHeaderType = .clear)
    case titleAndBack(String, header: NavigationHeaderType = .clear)
    case none(header: NavigationHeaderType = .clear)
}

struct ByeBooNavigationBar {
    
    static func makeNavigationBar(
        navigationItem: UINavigationItem,
        navigationController: UINavigationController?,
        type: NavigationBarType,
        action: Selector? = nil
    ) {
        
        let barAppearance = makeBasicBarAppearance(type: type)
        
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
    
    private static func makeBasicBarAppearance(type: NavigationBarType) -> UINavigationBarAppearance {
        let barAppearance = UINavigationBarAppearance()
        
        let headerType: NavigationHeaderType
        switch type {
        case .back(let header), 
             .close(let header),
             .none(let header),
             .title(_, let header),
             .titleAndClose(_, let header),
             .titleAndBack(_, let header):
            headerType = header
        }
        
        barAppearance.do {
            switch headerType {
            case .clear:
                $0.configureWithTransparentBackground()
            case .black:
                $0.backgroundColor = .grayscale900
                $0.shadowColor = .clear
            }
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
            
        case .title(let string, _):
            navigationItem.title = string
            
        case .close:
            makeCloseButtonItem(
                image: .xicon,
                target: topViewController,
                navigationItem: navigationItem,
                action: action
            )
            
        case .titleAndClose(let string, _):
            makeCloseButtonItem(
                image: .xicon,
                target: topViewController,
                navigationItem: navigationItem,
                action: action
            )
            navigationItem.title = string
            
        case .titleAndBack(let string, _):
            navigationItem.title = string
            let backButtonItem = makeBarButtonItem(
                image: .left.withTintColor(.white),
                target: topViewController,
                action: action
            )
            navigationItem.leftBarButtonItem = backButtonItem
            
        case .none:
            let emptyItem = makeBarButtonItem(
                image: UIImage(),
                target: topViewController,
                action: nil
            )
            navigationItem.leftBarButtonItem = emptyItem
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
