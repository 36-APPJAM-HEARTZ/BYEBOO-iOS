//
//  UIView+.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/28/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
