//
//  UINavigationController+.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 11/30/25.
//

import UIKit

extension UINavigationController {
    func pushFromLeftToRight(_ viewController: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.layer.add(transition, forKey: kCATransition)
        self.pushViewController(viewController, animated: false)
    }
}
