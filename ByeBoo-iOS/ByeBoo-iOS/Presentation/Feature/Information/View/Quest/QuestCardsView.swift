//
//  FeelingCardsView.swift
//  Tving
//
//  Created by APPLE on 7/6/25.
//

import UIKit

import SnapKit
import Then

final class QuestCardsView: BaseView {
    
    private(set) var questCards = [
        QuestCardView(
            title: "질문에 답하기",
            subTitle: "질문을 통해 상황과 감정을 정리해요",
            image: .book
        ),
        QuestCardView(
            title: "활동 인증하기",
            subTitle: "작은 미션을 통해 몸과 마음을 가볍게 해요",
            image: .shoe
        )
    ]
    
    private let questStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        questStackView.do {
            $0.axis = .horizontal
            $0.spacing = 11
            $0.distribution = .equalSpacing
        }
    }
    
    override func setUI() {
        questCards.forEach { questStackView.addArrangedSubview($0) }
        addSubview(questStackView)
    }
    
    override func setLayout() {
        questStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(327.adjustedW)
            $0.height.equalTo(198.adjustedH)
        }
        
        questCards.forEach { card in
            card.snp.makeConstraints {
                $0.width.equalTo(158.adjustedW)
                $0.height.equalTo(198.adjustedH)
            }
        }
    }
    
    private func setAction() {
        questCards.forEach {
            let tap = UITapGestureRecognizer(target: self, action: #selector(cardDidTap(_:)))
            $0.addGestureRecognizer(tap)
            $0.isUserInteractionEnabled = true
        }
    }
    
    @objc
    private func cardDidTap(_ sender: UITapGestureRecognizer) {
        guard let tappedCard = sender.view as? QuestCardView else { return }
        questCards.forEach { $0.isSelected = ($0 == tappedCard) }
    }
}
