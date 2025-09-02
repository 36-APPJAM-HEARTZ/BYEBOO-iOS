//
//  HomeOnboardingView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

import Lottie

final class HomeOnboardingView: BaseView {

    private let backgroundImageView = UIImageView()
    private let backgroundView = UIView()
    private let descriptionLabel = UILabel()
    private let speechBoxView = SpeechTextBoxView(title: "")
    let characterLottie = LottieAnimationView(name: "bori_newborn")
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
        characterLottie.do {
            $0.play()
            $0.loopMode = .loop
            $0.contentMode = .scaleAspectFill
            $0.isUserInteractionEnabled = true
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
            speechBoxView,
            characterLottie,
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
            $0.top.equalTo(speechBoxView.snp.top)
            $0.centerX.equalToSuperview()
        }
        speechBoxView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(316.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        characterLottie.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(143.adjustedH)
            $0.width.height.equalTo(259.adjustedH)
            $0.centerX.equalToSuperview()
        }
        foregroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension HomeOnboardingView {
    func startAnimation() {
        UIView.transition(with: self.speechBoxView, duration: 0.8, options: .transitionCrossDissolve) {
            self.speechBoxView.updateText("바이부에 오신 걸 환영해요!")
        } completion: { _ in
            UIView.transition(with: self.speechBoxView, duration: 0.8, options: .transitionCrossDissolve) {
                self.speechBoxView.updateText("저는 보리라고 해요.")
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    UIView.transition(with: self.speechBoxView, duration: 1, options: .transitionCrossDissolve) {
                        self.speechBoxView.updateText("여정을 시작하러 가볼까요?")
                        
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
