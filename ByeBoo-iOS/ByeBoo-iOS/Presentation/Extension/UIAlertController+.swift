//
//  UIAlertController+.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 11/25/25.
//

import UIKit

extension UIAlertController {
    
    func addActions(_ actions: UIAlertAction...) {
        actions.forEach { self.addAction($0) }
    }
}
