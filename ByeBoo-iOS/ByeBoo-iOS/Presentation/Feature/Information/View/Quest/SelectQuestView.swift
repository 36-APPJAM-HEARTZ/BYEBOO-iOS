//
//  SelectQuestView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/8/25.
//

import UIKit

import SnapKit
import Then

final class SelectQuestView: BaseView {
    
    private let titleView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    let questCardsView: QuestCardsView
    
    init(questCardsView: QuestCardsView) {
        self.questCardsView = questCardsView
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        titleView.backgroundColor = .clear
        
        titleLabel.do {
            $0.attributedText = "퀘스트 방식을 골라주세요".makeTitle(rangedText: "퀘스트 방식")
            $0.textAlignment = .left
            $0.font = FontManager.head1M24.font
        }
        
        subTitleLabel.do {
            $0.text = "나에게 맞는 방식으로 퀘스트를 받아볼 수 있어요."
            $0.textColor = .grayscale400
            $0.textAlignment = .left
            $0.font = FontManager.body5R14.font
        }
        
        questCardsView.backgroundColor = .clear
    }
    
    override func setUI() {
        titleView.addSubviews(titleLabel, subTitleLabel)
        addSubviews(titleView, questCardsView)
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
        
        questCardsView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.width.equalTo(375.adjustedW)
            $0.height.equalTo(214.adjustedH)
        }
    }
    
    func resetSelected() {
        self.questCardsView.questCards.forEach {
            $0.isSelected = false
        }
    }
}
