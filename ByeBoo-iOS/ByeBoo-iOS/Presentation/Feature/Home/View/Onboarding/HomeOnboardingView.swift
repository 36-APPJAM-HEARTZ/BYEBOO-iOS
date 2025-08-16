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
    private let descriptionLabel = UILabel()
    private let bubbleImageView = UIImageView()
    private let speechLabel = UILabel()
    let characterImageView = UIImageView()
    private let foregroundView = UIView()
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgLight
        }
        backgroundView.do {
            $0.backgroundColor = .black80
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
        }
        speechLabel.do {
            $0.font = FontManager.body2M16.font
            $0.textColor = .primary50
            $0.textAlignment = .center
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
            descriptionLabel,
            bubbleImageView,
            speechLabel,
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
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(bubbleImageView.snp.top)
            $0.centerX.equalToSuperview()
        }
        bubbleImageView.snp.makeConstraints {
            $0.bottom.equalTo(characterImageView.snp.top).offset(-36.adjustedH)
            $0.centerX.equalToSuperview()
        }
        speechLabel.snp.makeConstraints {
            $0.top.equalTo(bubbleImageView.snp.top).inset(14.adjustedH)
            $0.centerX.equalToSuperview()
        }
        characterImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(143.adjustedH)
            $0.centerX.equalToSuperview()
        }
        foregroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension HomeOnboardingView {
    func startAnimation() {
        UIView.transition(with: self.speechLabel, duration: 0.5, options: .transitionCrossDissolve) {
            self.speechLabel.text = "바이부에 오신 걸 환영해요!"
        } completion: { _ in
            UIView.transition(with: self.speechLabel, duration: 0.5, options: .transitionCrossDissolve) {
                self.speechLabel.text = "저는 보리라고 해요."
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.transition(with: self.speechLabel, duration: 1, options: .transitionCrossDissolve) {
                        self.speechLabel.text = "여정을 시작하러 가볼까요?"
                        
                        self.descriptionLabel.alpha = 1
                        self.descriptionLabel.transform = CGAffineTransform(translationX: 0, y: -37.adjustedH)
                    }
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
