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
        
        tipDescriptionLabel.applyByeBooFont(
            style: .body3R16,
            text: "카드를 뒤집어서 내용을 확인해 주세요!",
            color: .white50
        )
    
        cardImageView.do {
            $0.isUserInteractionEnabled = true
        }
        
        descriptionImageView.do {
            $0.isUserInteractionEnabled = true
            $0.isHidden = true
        }
        
        descriptionLabel.do {
            $0.applyByeBooFont(
                style: .body6R14,
                color: .secondary50,
                textAlignment: .center,
                numberOfLines: 0
            )
            $0.isHidden = true
        }
        
        confirmLabel.do {
            $0.applyByeBooFont(
                style: .body4Sb14,
                text: "확인했어요",
                color: .secondary300,
                textAlignment: .center
            )
            $0.underLine(text: $0.text ?? "")
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
        // iPhone Duo 대응
        // - 안내 문구, 카드, 확인 버튼을 한 덩어리로 safe area 가운데에 둠 (기존 디자인도 812pt 기준 가운데)
        // - 높이가 낮은 화면(펼친 Duo 가로, 외부 디스플레이)에서는 카드가 290:420 비율을 유지한 채 줄어듦
        tipDescriptionLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(safeAreaLayoutGuide).inset(24)
            $0.bottom.equalTo(containerView.snp.top).offset(-32)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
        containerView.snp.makeConstraints {
            $0.centerY.equalTo(safeAreaLayoutGuide)
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.width.equalTo(containerView.snp.height).multipliedBy(290.0 / 420.0)
            $0.height.lessThanOrEqualTo(420)
            $0.height.equalTo(420).priority(.high)
        }
        cardImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        descriptionImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            // 카드 높이 420 중 139 위치를 카드 크기에 비례하게 유지
            $0.top.equalTo(descriptionImageView.snp.bottom).multipliedBy(139.0 / 420.0)
            $0.centerX.equalToSuperview()
        }
        confirmLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(32)
            $0.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).inset(24)
            $0.centerX.equalTo(safeAreaLayoutGuide)
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
