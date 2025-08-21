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
    
    private let appleLoginButton = UIButton()
    private let kakaoLoginButton = UIButton()
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgLight
        }
        
        logoImageView.do {
            $0.image = .logo
        }
        
        appleLoginButton.do {
            $0.setImage(.appleLoginButton, for: .normal)
        }
        
        kakaoLoginButton.do {
            $0.setImage(.kakaoLoginButton, for: .normal)
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
            $0.top.equalToSuperview().inset(265.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(314.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(16.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
    }
}
