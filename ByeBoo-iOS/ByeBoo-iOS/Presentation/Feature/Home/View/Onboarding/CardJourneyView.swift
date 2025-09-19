//
//  CardJourneyView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/14/25.
//

import UIKit

final class CardJourneyView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private let backgroundView = UIView()
    
    private let containerView = UIView()
    private let tipDescriptionLabel = UILabel()
    private(set) var cardImageView = UIImageView()
    
    private let descriptionImageView = UIImageView()
    private let descriptionLabel = UILabel()
    
    private(set) var confirmLabel = UILabel()
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgDark
        }
        backgroundView.do {
            $0.backgroundColor = .black50
        }
        tipDescriptionLabel.do {
            $0.text = "카드를 뒤집어서 내용을 확인해 주세요!"
            $0.font = FontManager.body3R16.font
            $0.textColor = .white50
        }
        
        cardImageView.do {
            $0.isUserInteractionEnabled = true
        }
        descriptionImageView.do {
            $0.isUserInteractionEnabled = true
            $0.isHidden = true
        }
        descriptionLabel.do {
            $0.numberOfLines = 0
            $0.font = FontManager.body6R14.font
            $0.textColor = .secondary50
            $0.textAlignment = .center
            $0.isHidden = true
        }
        confirmLabel.do {
            $0.text = "확인했어요"
            $0.underLine(text: $0.text ?? "")
            $0.font = FontManager.body4Sb14.font
            $0.textColor = .secondary300
            $0.textAlignment = .center
            $0.isHidden = true
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            backgroundView,
            tipDescriptionLabel,
            containerView,
            confirmLabel
        )
        containerView.addSubviews(cardImageView, descriptionImageView)
        descriptionImageView.addSubview(descriptionLabel)
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tipDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(145.adjustedH)
            $0.centerX.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.top.equalTo(tipDescriptionLabel.snp.bottom).offset(32.adjustedH)
            $0.centerX.equalToSuperview()
        }
        cardImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(290.adjustedW)
            $0.height.equalTo(420.adjustedH)
        }
        descriptionImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(290.adjustedW)
            $0.height.equalTo(420.adjustedH)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(139.adjustedH)
            $0.centerX.equalToSuperview()
        }
        confirmLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(32.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
}

extension CardJourneyView {
    func updateName(name: String) {
        
    }
    func updateJourney(
        journeyType: JourneyType,
        journeyDescription: String
    ) {
        cardImageView.image = journeyType.frontImage
        descriptionImageView.image = journeyType.backImage
        descriptionLabel.text = journeyDescription
    }
    
    func flipCard() {
        
        UIView.transition(
            from: cardImageView,
            to: descriptionImageView,
            duration: 0.3,
            options: .transitionFlipFromLeft
        )
        
        descriptionImageView.isHidden = false
        descriptionLabel.isHidden = false
        confirmLabel.isHidden = false
        cardImageView.isHidden = true
        tipDescriptionLabel.isHidden = true
    }
}
