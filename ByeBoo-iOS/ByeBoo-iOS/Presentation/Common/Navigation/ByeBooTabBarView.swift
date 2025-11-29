//
//  ByeBooTabBarView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 11/30/25.
//

import UIKit

final class ByeBooTabBarView: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 96.adjustedH
        return size
    }
}

