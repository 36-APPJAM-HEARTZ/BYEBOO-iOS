//
//  LoginView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/19/25.
//

import UIKit

import SnapKit
import Then

//enum ConstraintMetric {
//    static let logoFirstTop = 336.adjustedH
//    static let logoChangedTop = 265.adjustedH
//    static let logoHeight = 57.adjustedH
//    static let logoToAppleButtonTop = 314.adjustedH
//    static let buttonHeight = 53.adjustedH
//    static let buttonSpacing = 16.adjustedH
//}

final class LoginView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private let logoImageView = UIImageView()
    
    private(set) var appleLoginButton = UIButton()
    private(set) var kakaoLoginButton = UIButton()
    
    private var logoTopConstraint: Constraint?
    private var appleButtonTopConstraint: Constraint?
    private var kakaoButtonTopConstraint: Constraint?
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgLight
        }
        
        logoImageView.do {
            $0.image = .logo
        }
        
        appleLoginButton.do {
            $0.setImage(.appleLoginButton, for: .normal)
            $0.alpha = 0
        }
        
        kakaoLoginButton.do {
            $0.setImage(.kakaoLoginButton, for: .normal)
            $0.alpha = 0
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            logoImageView,
            appleLoginButton,
            kakaoLoginButton
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            self.logoTopConstraint = $0.top.equalToSuperview().inset(336.adjustedH).constraint
            $0.centerX.equalToSuperview()
            $0.height.equalTo(53.adjustedH)
        }
        
        appleLoginButton.snp.makeConstraints {
            self.appleButtonTopConstraint = $0.top.equalToSuperview().offset(UIScreen.main.bounds.height + 100).constraint
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(53.adjustedH)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            self.kakaoButtonTopConstraint = $0.top.equalToSuperview().offset(UIScreen.main.bounds.height + 100).constraint
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
    }
    
    func startAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.logoTopConstraint?.update(inset: 265.adjustedH)
            self.appleButtonTopConstraint?.update(offset: 265.adjustedH + 57.adjustedH + 314.adjustedH)
            self.kakaoButtonTopConstraint?.update(offset: 265.adjustedH + 57.adjustedH + 314.adjustedH + 53 + 16.adjustedH)
            
            
            UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut]) {
                self.appleLoginButton.alpha = 1
                self.kakaoLoginButton.alpha = 1
                self.layoutIfNeeded()
            }
        }
    }
}
