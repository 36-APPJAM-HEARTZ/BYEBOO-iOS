//
//  AIAnswerCardView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 2/18/26.
//

import UIKit

final class AIAnswerCardView: BaseView {
    
    private let cardImageView = UIImageView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let contentLabel = UILabel()
    private let boriLabel = UILabel()
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        cardImageView.do {
            $0.image = .boriLetter
            $0.isUserInteractionEnabled = true
        }
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        contentLabel.do {
            $0.applyByeBooFont(
                style: .body3R16,
                text: "",
                color: .primary50
            )
            $0.numberOfLines = 0
        }
        boriLabel.do {
            $0.applyByeBooFont(
                style: .boriVoiceR18,
                text: "보리의 답장",
                color: .primary50
            )
        }
    }
    
    override func setUI() {
        addSubviews(cardImageView)
        cardImageView.addSubviews(scrollView, boriLabel)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentLabel)
    }
    
    override func setLayout() {
        cardImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(217.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(98.adjustedH)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        contentLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        boriLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(44.adjustedH)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
        }
    }
}

extension AIAnswerCardView {
    func updateText(answer: String) {
        contentLabel.applyByeBooFont(
            style: .boriVoiceR18,
            text: answer,
            color: .primary50
        )
    }
}
