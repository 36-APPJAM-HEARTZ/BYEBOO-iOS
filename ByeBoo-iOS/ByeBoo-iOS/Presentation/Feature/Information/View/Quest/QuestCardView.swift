//
//  FeelingCardView.swift
//  Tving
//
//  Created by APPLE on 7/6/25.
//

import UIKit

import SnapKit
import Then

final class QuestCardView: BaseView {
    
    var isSelected: Bool = false {
        didSet { updateCard() }
    }
    
    var onSelected: (() -> Void)?
    
    init(title: String, subTitle: String, image: UIImage) {
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
        self.cardImageView.image = image
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backgroundView = UIView()
    private let cardImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    override func setStyle() {
        backgroundView.do {
            $0.backgroundColor = .white10
            $0.layer.cornerRadius = 12
        }
        
        cardImageView.do {
            $0.backgroundColor = .clear
        }
        
        titleLabel.do {
            $0.textColor = .grayscale300
            $0.textAlignment = .center
            $0.font = FontManager.sub3M18.font
        }
        
        subTitleLabel.do {
            $0.textColor = .grayscale300
            $0.textAlignment = .center
            $0.font = FontManager.body5R14.font
            $0.numberOfLines = 3
        }
        
        setBlurEffect()
    }
    
    override func setUI() {
        backgroundView.addSubviews(cardImageView, titleLabel, subTitleLabel)
        addSubview(backgroundView)
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.width.equalTo(158.adjustedW)
            $0.height.equalTo(198.adjustedH)
        }
        
        cardImageView.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.top).offset(23.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(56.adjustedW)
            $0.height.equalTo(56.adjustedH)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(cardImageView.snp.bottom).offset(10.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(114.adjustedW)
            $0.height.equalTo(22.adjustedH)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(114.adjustedW)
            $0.height.equalTo(54.adjustedH)
        }
    }
    
    private func updateCard() {
        onSelected?()
        
        if isSelected {
            titleLabel.textColor = .primary300
            subTitleLabel.textColor = .primary200
            backgroundView.layer.borderWidth = 2
            backgroundView.layer.borderColor = UIColor.primary300.cgColor
        } else {
            titleLabel.textColor = .grayscale300
            subTitleLabel.textColor = .grayscale300
            backgroundView.layer.borderWidth = 0
        }
    }
    
    private func setBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        insertSubview(blurView, at: 0)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
