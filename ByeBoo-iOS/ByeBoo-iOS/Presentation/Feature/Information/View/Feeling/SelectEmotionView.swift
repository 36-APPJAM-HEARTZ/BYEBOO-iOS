//
//  SelectEmotionView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/8/25.
//

import UIKit

import SnapKit
import Then

final class SelectEmotionView: BaseView {
    
    private let titleView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private(set) var emotionCardsView: EmotionCardsView
    
    init(emotionCardsView: EmotionCardsView) {
        self.emotionCardsView = emotionCardsView
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        titleView.backgroundColor = .clear
        
        titleLabel.applyByeBooFont (
            style: FontManager.head1M24,
            text:"감정 상태를 알려주세요",
            color: .grayscale50,
            textAlignment: .left
        )
        
        subTitleLabel.applyByeBooFont (
            style: FontManager.body6R14,
            text: "이별 후, 어떤 감정으로 하루를 보내고 계신가요?",
            color: .grayscale400,
            textAlignment: .left
        )
        
        emotionCardsView.backgroundColor = .clear
    }
    
    override func setUI() {
        titleView.addSubviews(titleLabel, subTitleLabel)
        addSubviews(titleView, emotionCardsView)
    }
    
    override func setLayout() {
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30.adjustedH)
            $0.width.equalTo(375.adjustedW)
            $0.height.equalTo(98.adjustedH)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15.adjustedH)
            $0.leading.equalToSuperview().inset(25.adjustedW)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(327.adjustedW)
            $0.height.equalTo(31.adjustedH)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9.adjustedH)
            $0.leading.equalToSuperview().inset(25.adjustedW)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(327.adjustedW)
            $0.height.equalTo(18.adjustedH)
        }
        
        emotionCardsView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.width.equalTo(375.adjustedW)
            $0.height.equalTo(168.adjustedH)
        }
    }
    
    func resetSelected() {
        self.emotionCardsView.emotionCards.forEach {
            $0.isSelected = false
        }
    }
}
