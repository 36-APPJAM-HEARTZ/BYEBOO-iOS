//
//  TabBarViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/12/26.
//

import UIKit

final class TabBarViewController<T: TabItem>: UITabBarController {
    
    private let topTabBar = TopTabBar(items: Array(T.allCases))
    
    override func viewDidLoad() {
        self.tabBar.isHidden = true
        view.addSubview(topTabBar)
        
        topTabBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let viewControllers = T.allCases.map { $0.viewController }
        setViewControllers(viewControllers, animated: false)
    }
}
