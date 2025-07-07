//
//  EmotionBottomSheet.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/7/25.
//

import UIKit

import SnapKit
import Then

final class EmotionBottomSheet: BaseViewController {
    private let grabber = UIImageView()
    private let titleLabel = UILabel()
    private let emotionChipFirstStackView = UIStackView()
    private let emotionChipSecondStackView = UIStackView()
    
    private let neturalEmotionChip = ByeBooEmotionChip(emotionType: .neutral)
    private let understandingEmotionChip = ByeBooEmotionChip(emotionType: .selfUnderstanding)
    private let sadEmotionChip = ByeBooEmotionChip(emotionType: .sad)
    private let relievedEmotionChip = ByeBooEmotionChip(emotionType: .relieved)
    
    private let confirmButton = ByeBooButton(titleText: "완료", type: .disabled)
    
    override func viewDidLoad() {
        setUI()
        setStyle()
        setBlurEffect()
        setLayout()
    }
    
    private func setUI() {
        view.addSubviews(
            grabber,
            titleLabel,
            emotionChipFirstStackView,
            emotionChipSecondStackView,
            confirmButton
        )
        
        emotionChipFirstStackView.addArrangedSubviews(neturalEmotionChip, understandingEmotionChip)
        emotionChipSecondStackView.addArrangedSubviews(sadEmotionChip, relievedEmotionChip)
    }
    
    private func setStyle() {
        self.view.backgroundColor = .grayscale90080
        
        grabber.do {
            $0.image = .homeIndicator
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.text = "퀘스트를 완료한 후,\n어떤 감정이 느껴지시나요?"
            $0.numberOfLines = 2
            $0.font = FontManager.head1Sb24.font
            $0.textColor = .grayscale50
            $0.textAlignment = .center
        }
        
        [emotionChipFirstStackView, emotionChipSecondStackView].forEach {
            $0.do {
                $0.axis = .horizontal
                $0.spacing = 20
            }
        }
    }
    
    private func setBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        view.insertSubview(blurView, at: 0)
    }
    
    private func setLayout() {
        grabber.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(80.adjustedW)
            $0.height.equalTo(6.adjustedH)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(grabber.snp.bottom).offset(33.adjustedH)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(96.adjustedH)
        }
        
        emotionChipFirstStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(3)
            $0.centerX.equalToSuperview()
        }
        
        emotionChipSecondStackView.snp.makeConstraints {
            $0.top.equalTo(emotionChipFirstStackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(emotionChipSecondStackView.snp.bottom).offset(37)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(327.adjustedW)
        }
    }
    
}
