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
    case backAndMenu(header: NavigationHeaderType = .clear)
    case backAndEdit(header: NavigationHeaderType = .clear)
    case title(String, header: NavigationHeaderType = .clear)
    case close(header: NavigationHeaderType = .clear)
    case titleAndClose(String, header: NavigationHeaderType = .clear)
    case titleAndBack(String, header: NavigationHeaderType = .clear)
    case editAndClose(header: NavigationHeaderType = .clear)
    case confirmAndBack(String, header: NavigationHeaderType = .clear)
    case none(header: NavigationHeaderType = .clear)
}

struct ByeBooNavigationBar {
    
    static func makeNavigationBar(
        navigationItem: UINavigationItem,
        navigationController: UINavigationController?,
        type: NavigationBarType,
        action: Selector? = nil,
        secondAction: Selector? = nil
    ) {
        
        let barAppearance = makeBasicBarAppearance(type: type)
        
        guard let topViewController = navigationController?.topViewController as? BaseViewController else {
            return
        }
        
        configureNavigationItem(
            navigationItem: navigationItem,
            topViewController: topViewController,
            type: type,
            action: action,
            secondAction: secondAction
        )
        
        registerBarAppearance(barAppearance, to: navigationController)
    }
    
    static func replaceHeaderType(
        from navigationController: UINavigationController,
        headerType: NavigationHeaderType
    ) {
        let barAppearance = setBarAppearance(headerType: headerType)
        registerBarAppearance(barAppearance, to: navigationController)
    }
    
    private static func makeBasicBarAppearance(type: NavigationBarType) -> UINavigationBarAppearance {
        let headerType = setHeaderType(barType: type)
        let barAppearance = setBarAppearance(headerType: headerType)
        
        return barAppearance
    }
    
    private static func setHeaderType(barType: NavigationBarType) -> NavigationHeaderType {
        let headerType: NavigationHeaderType
        
        switch barType {
        case .back(let header),
                .backAndMenu(let header),
                .backAndEdit(let header),
                .close(let header),
                .none(let header),
                .title(_, let header),
                .titleAndClose(_, let header),
                .editAndClose(let header),
                .titleAndBack(_, let header),
                .confirmAndBack(_, let header):
            headerType = header
        }
        return headerType
    }
    
    private static func setBarAppearance(headerType: NavigationHeaderType) -> UINavigationBarAppearance {
        let barAppearance = UINavigationBarAppearance()
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
            
            $0.buttonAppearance.normal.titleTextAttributes = [
                .font: FontManager.body2M16.font,
                .foregroundColor: UIColor.primary300
            ]
            
            $0.buttonAppearance.disabled.titleTextAttributes = [
                .font: FontManager.body2M16.font,
                .foregroundColor: UIColor.grayscale600
            ]
        }
        return barAppearance
    }
    
    private static func configureNavigationItem(
        navigationItem: UINavigationItem,
        topViewController: BaseViewController,
        type: NavigationBarType,
        action: Selector?,
        secondAction: Selector? = nil
    ) {
        switch type {
        case .back:
            let backButtonItem = makeBarButtonItem(
                image: .left.withTintColor(.white),
                target: topViewController,
                action: action
            )
            navigationItem.leftBarButtonItems = [makeSpacer(), backButtonItem]
            
        case .backAndMenu:
            let backButtonItem = makeBarButtonItem(
                image: .left.withTintColor(.white),
                target: topViewController,
                action: action
            )
            navigationItem.leftBarButtonItems = [makeSpacer(), backButtonItem]
            makeTopRightButtonItem(
                image: .menu,
                target: topViewController,
                navigationItem: navigationItem,
                action: secondAction,
                padding: 0
            )
        case .backAndEdit:
            let backButtonItem = makeBarButtonItem(
                image: .left.withTintColor(.white),
                target: topViewController,
                action: action
            )
            navigationItem.leftBarButtonItem = backButtonItem
            
            let editButtonItem = makeBarButtonItem(
                image: .edit,
                target: topViewController,
                action: secondAction
            )
            navigationItem.rightBarButtonItem = editButtonItem
            
        case .title(let string, _):
            navigationItem.title = string
            
        case .close:
            makeTopRightButtonItem(
                image: .xicon,
                target: topViewController,
                navigationItem: navigationItem,
                action: action
            )
            
        case .titleAndClose(let string, _):
            navigationItem.title = string
            makeTopRightButtonItem(
                image: .xicon,
                target: topViewController,
                navigationItem: navigationItem,
                action: action
            )
            
        case .titleAndBack(let string, _):
            navigationItem.title = string
            let backButtonItem = makeBarButtonItem(
                image: .left.withTintColor(.white),
                target: topViewController,
                action: action
            )
            navigationItem.leftBarButtonItems = [makeSpacer(), backButtonItem]
            
        case .editAndClose:
            let editButtonItem = makeBarButtonItem(
                image: .edit,
                target: topViewController,
                action: secondAction
            )
            navigationItem.leftBarButtonItems = [makeSpacer(), editButtonItem]
            makeTopRightButtonItem(
                image: .xicon,
                target: topViewController,
                navigationItem: navigationItem,
                action: action,
                padding: 8.adjustedH
            )
        case .confirmAndBack:
            let backButtonItem = makeBarButtonItem(
                image: .left.withTintColor(.white),
                target: topViewController,
                action: action
            )
            let confirmButtonItem = makeBarButtonItem(
                title: "완료",
                target: topViewController,
                action: secondAction
            )
            navigationItem.leftBarButtonItems = [makeSpacer(), backButtonItem]
            navigationItem.rightBarButtonItems = [makeSpacer(padding: 16), confirmButtonItem]
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
        image: UIImage? = nil,
        title: String? = nil,
        target: BaseViewController,
        action: Selector?
    ) -> UIBarButtonItem {
        if let image {
            return UIBarButtonItem(
                image: image.withTintColor(.white).withRenderingMode(.alwaysOriginal),
                style: .plain,
                target: target,
                action: action
            )
        }
        
        if let title {
            return UIBarButtonItem(
                title: title,
                style: .plain,
                target: target,
                action: action
            )
        }
        
        return UIBarButtonItem(
            title: "기본",
            style: .plain,
            target: target,
            action: action
        )
    }
    
    private static func makeTopRightButtonItem(
        image: UIImage,
        target: BaseViewController,
        navigationItem: UINavigationItem,
        action: Selector?,
        padding: CGFloat = 16.adjustedW
    ) {
        let closeButtonItem = makeBarButtonItem(image: image, target: target, action: action)
        let spacer = makeSpacer(padding: padding)
        navigationItem.rightBarButtonItems = [spacer, closeButtonItem]
    }
    
    private static func makeSpacer(padding: CGFloat = 2.adjustedW) -> UIBarButtonItem {
        let spacer = UIBarButtonItem(
            barButtonSystemItem: .fixedSpace,
            target: nil,
            action: nil
        )
        spacer.width = padding
        
        return spacer
    }
}
