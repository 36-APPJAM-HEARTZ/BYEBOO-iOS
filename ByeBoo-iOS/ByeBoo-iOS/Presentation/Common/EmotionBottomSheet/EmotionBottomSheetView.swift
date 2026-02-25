//
//  EmotionBottomSheetView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/7/25.
//

import UIKit

import SnapKit
import Then

final class EmotionBottomSheetView: BaseView {
    private let titleLabel = UILabel()
    private let warningStackView = UIStackView()
    private let warningIcon = UIImageView()
    private let warningLabel = UILabel()
    
    private let emotionChipFirstStackView = UIStackView()
    private let emotionChipSecondStackView = UIStackView()
    
    let confirmButton = ByeBooButton(titleText: "완료하기", type: .disabled)
    var emotionChips: [ByeBooEmotionChip] = []
    
    override func setUI() {
        addSubviews(
            titleLabel,
            emotionChipFirstStackView,
            emotionChipSecondStackView,
            confirmButton,
            warningStackView
        )
        
        warningStackView.addArrangedSubviews(warningIcon, warningLabel)
        
        ByeBooEmotion.allCases.enumerated().forEach { _, emotion in
            let chip = ByeBooEmotionChip(emotionType: emotion)
            emotionChips.append(chip)
            
            switch emotion {
            case .neutral, .selfUnderstanding:
                emotionChipFirstStackView.addArrangedSubview(chip)
            case .sad, .relieved:
                emotionChipSecondStackView.addArrangedSubview(chip)
            }
        }
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        titleLabel.applyByeBooFont(
            style: .head2M22,
            text: "퀘스트를 완료한 후,\n어떤 감정이 느껴지시나요?",
            color: .grayscale50,
            textAlignment: .center,
            numberOfLines: 2
        )
        
        warningStackView.do {
            $0.axis = .horizontal
            $0.spacing = 3.adjustedW
        }
        
        warningIcon.do {
            $0.image = .error
            $0.contentMode = .scaleAspectFit
        }
        
        warningLabel.applyByeBooFont(
            style: .cap2R12,
            text: "퀘스트 완료 후에는 감정을 수정할 수 없어요",
            color: .grayscale400
        )
        
        [emotionChipFirstStackView, emotionChipSecondStackView].forEach {
            $0.do {
                $0.axis = .horizontal
                $0.spacing = 20.adjustedW
            }
        }
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(53.adjustedH)
            $0.centerX.equalToSuperview()
//            $0.height.equalTo(62.adjustedH)
        }
        
        warningStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        warningIcon.snp.makeConstraints {
            $0.width.height.equalTo(16.adjustedW)
        }
        
        emotionChipFirstStackView.snp.makeConstraints {
            $0.top.equalTo(warningStackView.snp.bottom).offset(16.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        emotionChipSecondStackView.snp.makeConstraints {
            $0.top.equalTo(emotionChipFirstStackView.snp.bottom).offset(24.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(emotionChipSecondStackView.snp.bottom).offset(37.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(327.adjustedW)
        }
    }
    
}
