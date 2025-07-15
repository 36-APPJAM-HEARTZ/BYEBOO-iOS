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
    
    func setBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        insertSubview(blurView, at: 0)
        blurView.do {
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
