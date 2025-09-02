//
//  SplashView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 9/2/25.
//

import UIKit

import SnapKit
import Then


final class SplashView: BaseView {
    private let backgroundImageView = UIImageView()
    private let logoImageView = UIImageView()
    let keychaindelete = UIButton()
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgLight
        }
        
        logoImageView.do {
            $0.image = .logo
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            logoImageView,
            keychaindelete
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(265.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        keychaindelete.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
