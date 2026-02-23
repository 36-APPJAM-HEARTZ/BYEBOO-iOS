//
//  AIAnswerView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 2/18/26.
//

import UIKit

final class AIAnswerView: BaseView {
    
    private let answerState: AIAnswerState
    
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    private let cardView = AIAnswerCardView()
    
    init(answerState: AIAnswerState) {
        self.answerState = answerState
        
        super.init(frame: .zero)
        updateState(state: answerState)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                text: answerState.text,
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
            $0.horizontalEdges.equalToSuperview().inset(48.adjustedW)
            $0.centerY.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.size.equalTo(100)
        }
        cardView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.centerY.equalToSuperview()
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
