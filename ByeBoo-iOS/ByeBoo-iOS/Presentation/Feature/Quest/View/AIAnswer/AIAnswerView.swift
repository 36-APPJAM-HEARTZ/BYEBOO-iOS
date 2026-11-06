//
//  AIAnswerView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 2/18/26.
//

import UIKit

final class AIAnswerView: BaseView {
    
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    let cardView = AIAnswerCardView()
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 8.adjustedH
            $0.alignment = .center
        }
        textLabel.do {
            $0.applyByeBooFont(
                style: .body3R16,
                text: AIAnswerState.loading.text,
                color: .grayscale100,
                textAlignment: .center
            )
            $0.numberOfLines = 0
        }
        imageView.do {
            $0.image = .boriWriting
        }
        cardView.do {
            $0.isHidden = true
        }
    }
    
    override func setUI() {
        addSubviews(stackView, cardView)
        stackView.addArrangedSubviews(imageView, textLabel)
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(48.adjustedW)
            $0.centerY.equalTo(safeAreaLayoutGuide)
        }
        imageView.snp.makeConstraints {
            $0.size.equalTo(100)
        }
        // 편지 이미지 비율(327 x 569) 그대로, 디자인 크기를 넘지 않고 화면이 작으면 줄어듦
        cardView.snp.makeConstraints {
            $0.center.equalTo(safeAreaLayoutGuide)
            $0.width.equalTo(cardView.snp.height).multipliedBy(327.0 / 569.0)
            $0.width.equalTo(327).priority(.high)
            $0.width.lessThanOrEqualTo(safeAreaLayoutGuide).offset(-48)
            $0.height.lessThanOrEqualTo(safeAreaLayoutGuide).offset(-32)
        }
    }
}

extension AIAnswerView {
    func updateState(state: AIAnswerState) {
        textLabel.applyByeBooFont(
            style: .body3R16,
            text: state.text,
            color: .grayscale100,
            textAlignment: .center
        )
        imageView.image = state.image
        
        switch state {
        case .loading:
            stackView.isHidden = false
            cardView.isHidden = true
        case .fail:
            stackView.isHidden = false
            cardView.isHidden = true
        case .success:
            stackView.isHidden = true
            cardView.isHidden = false
        }
    }
}
