//
//  UIViewController+.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 6/9/26.
//

import UIKit

extension UIViewController {
    func presentBottomSheet(_ viewController: UIViewController, height: CGFloat) {
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.custom { _ in height }]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 8
        }
        self.present(viewController, animated: true)
    }
}
