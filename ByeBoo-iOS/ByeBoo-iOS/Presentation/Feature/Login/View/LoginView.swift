//
//  LoginView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/19/25.
//

import UIKit

import SnapKit
import Then

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
            $0.image = .bgDark
        }
        
        logoImageView.do {
            $0.image = .logo
            $0.contentMode = .scaleAspectFit
        }
        
        appleLoginButton.do {
            $0.setImage(.appleLoginButton, for: .normal)
            $0.alpha = 0
            $0.isExclusiveTouch = true
        }

        kakaoLoginButton.do {
            $0.setImage(.kakaoLoginButton, for: .normal)
            $0.alpha = 0
            $0.isExclusiveTouch = true
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
            self.appleButtonTopConstraint = $0.top.equalToSuperview().constraint
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(53.adjustedH)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            self.kakaoButtonTopConstraint = $0.top.equalToSuperview().constraint
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
    }
    
    func startAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // 화면 아래에서 올라오도록 현재 뷰 높이 기준으로 시작 위치 설정
            let hiddenOffset = self.bounds.height + 100
            self.appleButtonTopConstraint?.update(offset: hiddenOffset)
            self.kakaoButtonTopConstraint?.update(offset: hiddenOffset)
            self.layoutIfNeeded()
            
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
