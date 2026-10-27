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
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = false
        
        switch type {
        case .back, .titleAndBack, .backAndMenu, .backAndEdit, .confirmAndBack:
            setBackButton(navigationItem: navigationItem, target: topViewController, action: action)
        case .none:
            navigationItem.hidesBackButton = true
        case .title, .close, .titleAndClose, .editAndClose:
            break
        }
        
        switch type {
        case .title(let string, _), .titleAndBack(let string, _), .titleAndClose(let string, _):
            navigationItem.title = string
        default:
            break
        }
        
        switch type {
        case .backAndMenu:
            navigationItem.rightBarButtonItem = makeBarButtonItem(image: .menu, target: topViewController, action: secondAction)
        case .backAndEdit:
            navigationItem.rightBarButtonItem = makeBarButtonItem(image: .edit, target: topViewController, action: secondAction)
        case .close, .titleAndClose:
            navigationItem.rightBarButtonItem = makeBarButtonItem(image: .xicon, target: topViewController, action: action)
        case .editAndClose:
            navigationItem.leftBarButtonItem = makeBarButtonItem(image: .edit, target: topViewController, action: secondAction)
            navigationItem.rightBarButtonItem = makeBarButtonItem(image: .xicon, target: topViewController, action: action)
        case .confirmAndBack(let title, _):
            navigationItem.rightBarButtonItem = makeBarButtonItem(title: title, target: topViewController, action: secondAction)
        default:
            break
        }
    }
    
    /// action이 없으면 시스템 back 버튼(스와이프 뒤로가기 포함)을 사용하고,
    /// 뒤로가기 전 확인 등 커스텀 동작이 필요한 경우에만 action으로 대체한다.
    private static func setBackButton(
        navigationItem: UINavigationItem,
        target: BaseViewController,
        action: Selector?
    ) {
        guard let action else { return }
        navigationItem.leftBarButtonItem = makeBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            target: target,
            action: action
        )
    }
    
    private static func registerBarAppearance(
        _ barAppearance: UINavigationBarAppearance,
        to navigationController: UINavigationController?
    ) {
        navigationController?.navigationBar.do {
            $0.standardAppearance = barAppearance
            $0.scrollEdgeAppearance = barAppearance
            $0.tintColor = .white
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
}
