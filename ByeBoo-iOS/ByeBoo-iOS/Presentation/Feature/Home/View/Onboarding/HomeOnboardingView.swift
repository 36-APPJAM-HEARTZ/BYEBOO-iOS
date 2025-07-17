//
//  HomeOnboardingView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

final class HomeOnboardingView: BaseView {

    private let backgroundImageView = UIImageView()
    private let backgroundView = UIView()
    private let welcomeView = OnboardingTextView(text: "BYE BOO에 오신 걸 환영해요 :)")
    private let introduceView = OnboardingTextView(text: "저는 보리라고 해요.")
    private let descriptionLabel = UILabel()
    private let bubbleImageView = UIImageView()
    let characterImageView = UIImageView()
    private let foregroundView = UIView()
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgLight
        }
        backgroundView.do {
            $0.backgroundColor = .black80
        }
        welcomeView.do {
            $0.alpha = 0
        }
        introduceView.do {
            $0.alpha = 0
        }
        descriptionLabel.do {
            $0.text = "보리를 꾹 눌러주세요!"
            $0.font = FontManager.body3R16.font
            $0.textColor = .white50
            $0.textAlignment = .center
            $0.alpha = 0
        }
        bubbleImageView.do {
            $0.image = .speechBubble
            $0.alpha = 0
        }
        characterImageView.do {
            $0.image = .newborn
        }
        foregroundView.do {
            $0.backgroundColor = .black
            $0.alpha = 0
        }
    }

    override func setUI() {
        addSubviews(
            backgroundImageView,
            backgroundView,
            welcomeView,
            introduceView,
            descriptionLabel,
            bubbleImageView,
            characterImageView,
            foregroundView
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        welcomeView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(72.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        introduceView.snp.makeConstraints {
            $0.top.equalTo(welcomeView.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(introduceView.snp.bottom).offset(119.adjustedH)
            $0.centerX.equalToSuperview()
        }
        bubbleImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16.adjustedH)
            $0.centerX.equalToSuperview()
        }
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(bubbleImageView.snp.bottom).offset(19.adjustedH)
            $0.centerX.equalToSuperview()
        }
        foregroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension HomeOnboardingView {
    func startAnimation() {
        
        UIView.animate(withDuration: 0.4, delay: 0.3) {
            self.welcomeView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 0.3) {
                self.introduceView.alpha = 1
            } completion: { _ in
                UIView.animate(withDuration: 0.4, delay: 0.2) {
                    self.descriptionLabel.alpha = 1
                    self.bubbleImageView.alpha = 1
                    self.characterImageView.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func startPressAnimation() {
        UIView.animate(withDuration: 0.7) {
            self.foregroundView.alpha = 1
        }
    }
    
    func revertPressAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.foregroundView.alpha = 0
        }
    }
}
