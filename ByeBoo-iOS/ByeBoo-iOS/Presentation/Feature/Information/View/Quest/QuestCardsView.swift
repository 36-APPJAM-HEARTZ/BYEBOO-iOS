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
            title: "재회 준비",
            subTitle: "X와의 재회를 위해\n나를 먼저 돌아보고\n상대를 이해해요",
            image: .reunion
        ),
        QuestCardView(
            title: "이별 극복",
            subTitle: "질문과 미션을 통해\n나만의 삶을\n회복해 나가요",
            image: .overcomingBreakup
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
