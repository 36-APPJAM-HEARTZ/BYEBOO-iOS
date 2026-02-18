//
//  AIAnswerCardView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 2/18/26.
//

import UIKit

final class AIAnswerCardView: BaseView {
    
    private let cardImageView = UIImageView()
    private let contentLabel = UILabel()
    private let boriLabel = UILabel()
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        cardImageView.do {
            $0.image = .boriLetter
        }
        contentLabel.do {
            // font 어떻게 되는거지?
            $0.applyByeBooFont(
                style: .body3R16,
                text: "",
                color: .primary50
            )
            $0.numberOfLines = 0
        }
        boriLabel.do {
            $0.applyByeBooFont(
                style: .body3R16,
                text: "보리의 답장",
                color: .primary50
            )
        }
    }
    
    override func setUI() {
        addSubviews(cardImageView)
        cardImageView.addSubviews(contentLabel, boriLabel)
    }
    
    override func setLayout() {
        cardImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.top.equalToSuperview().offset(217.adjustedH)
        }
        boriLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(44.adjustedH)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
        }
    }
}

extension AIAnswerCardView {
    func updateText(answer: String) {
        contentLabel.text = answer
    }
}
