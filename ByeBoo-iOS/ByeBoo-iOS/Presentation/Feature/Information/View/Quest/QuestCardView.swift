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
            $0.backgroundColor = .white5
            $0.layer.cornerRadius = 12
            setBlurEffect(alpha: 0.5)
        }
        
        cardImageView.do {
            $0.backgroundColor = .clear
        }
        
        titleLabel.applyByeBooFont (
            style: .sub3M18,
            color: .grayscale300,
            textAlignment: .center
        )
        
        subTitleLabel.applyByeBooFont (
            style: .body6R14,
            color: .grayscale300,
            textAlignment: .center,
            numberOfLines: 3
        )
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
            $0.height.equalTo(63.adjustedH)
        }
    }
    
    private func updateCard() {
        onSelected?()
        
        if isSelected {
            titleLabel.applyByeBooFont(style: .sub2Sb18, color: .primary200)
            subTitleLabel.applyByeBooFont(style: .body5M14, color: .primary200)
            backgroundView.do {
                $0.backgroundColor = .primary30020
                $0.layer.borderWidth = 2
                $0.layer.borderColor = UIColor.primary300.cgColor
            }
        } else {
            titleLabel.applyByeBooFont(style: .sub3M18, color: .grayscale300)
            subTitleLabel.applyByeBooFont(style: .body6R14, color: .grayscale300)
            backgroundView.do {
                $0.backgroundColor = .white5
                $0.layer.borderWidth = 0
            }
        }
    }
}
