//
//  FeelingCardsView.swift
//  Tving
//
//  Created by APPLE on 7/6/25.
//

import UIKit

import SnapKit
import Then

final class EmotionCardsView: BaseView {
    
    let emotionCards = [
        EmotionCardView(state: "너무 힘들어요", image: .sad),
        EmotionCardView(state: "극복 중이에요", image: .soso),
        EmotionCardView(state: "꽤 극복했어요", image: .good)
    ]
    
    private let emotionStackView = UIStackView()
    
    var onEmotionSelected: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        emotionStackView.do {
            $0.axis = .horizontal
            $0.spacing = 11
            $0.distribution = .equalSpacing
        }
    }
    
    override func setUI() {
        emotionCards.forEach { emotionStackView.addArrangedSubview($0) }
        addSubview(emotionStackView)
    }
    
    override func setLayout() {
        emotionStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(325.adjustedW)
            $0.height.equalTo(152.adjustedH)
        }
        
        emotionCards.forEach { card in
            card.snp.makeConstraints {
                $0.width.equalTo(101.adjustedW)
                $0.height.equalTo(152.adjustedH)
            }
        }
    }
    
    private func setAction() {
        emotionCards.forEach {
            let tap = UITapGestureRecognizer(target: self, action: #selector(cardDidTap(_:)))
            $0.addGestureRecognizer(tap)
            $0.isUserInteractionEnabled = true
        }
    }
    
    @objc
    private func cardDidTap(_ sender: UITapGestureRecognizer) {
        guard let tappedCard = sender.view as? EmotionCardView else { return }

        for index in 0..<emotionCards.count {
            let card = emotionCards[index]
            card.isSelected = (card == tappedCard)
            onEmotionSelected?(index)
        }
    }
}
