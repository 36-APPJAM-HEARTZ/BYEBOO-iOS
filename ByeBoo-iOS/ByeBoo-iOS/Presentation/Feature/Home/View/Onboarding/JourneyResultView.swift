//
//  JourneyResultView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

enum JourneyType: String {
    case face = "감정 직면"
    case process = "감정 정리"
    
    var image: UIImage {
        switch self {
        case .face:
                .faceEmotion
        case .process:
                .processEmotion
        }
    }
    
    var description: String {
        return "\(rawValue) 여정"
    }
    
    var frontImage: UIImage {
        switch self {
        case .face:
                .faceFront
        case .process:
                .processFront
        }
    }
    
    var backImage: UIImage {
        switch self {
        case .face:
                .faceBack
        case .process:
                .processBack
        }
    }
}

final class JourneyResultView: BaseView {

    private let backgroundImageView = UIImageView()
    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    let confirmLabel = UILabel()
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgLight
        }
        backgroundView.do {
            $0.backgroundColor = .black50
        }
        titleLabel.do {
            $0.font = FontManager.body1Sb16.font
            $0.textColor = .white
        }
        descriptionLabel.do {
            $0.numberOfLines = 0
            $0.font = FontManager.body5R14.font
            $0.textColor = .secondary100
            $0.textAlignment = .center
        }
        confirmLabel.do {
            $0.text = "확인했어요"
            $0.underLine(text: $0.text ?? "")
            $0.font = FontManager.body4Sb14.font
            $0.textColor = .secondary300
            $0.textAlignment = .center
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            backgroundView,
            titleLabel,
            imageView,
            descriptionLabel,
            confirmLabel
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(74.5.adjustedH)
            $0.centerX.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24.adjustedH)
            $0.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(24.adjustedH)
            $0.centerX.equalToSuperview()
        }
        confirmLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
}

extension JourneyResultView {
    func updateName(name: String) {
        titleLabel.text = "지금 \(name) 님에게 필요한 건"
    }
    func updateJourney(
        journeyType: JourneyType,
        journeyDescription: String
    ) {
        imageView.image = journeyType.image
        descriptionLabel.text = journeyDescription
    }
}
