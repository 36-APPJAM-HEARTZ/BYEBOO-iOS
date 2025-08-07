//
//  FeelingCardView.swift
//  Tving
//
//  Created by APPLE on 7/6/25.
//

import UIKit

import SnapKit
import Then

final class EmotionCardView: BaseView {
    
    var isSelected: Bool = false {
        didSet { updateCard() }
    }
    
    var onSelected: (() -> Void)?
    
    init(state: String, image: UIImage) {
        self.stateLabel.text = state
        self.cardImageView.image = image
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backgroundView = UIView()
    private let cardImageView = UIImageView()
    private let stateLabel = UILabel()
    
    override func setStyle() {
        backgroundView.do {
            $0.backgroundColor = .white10
            $0.layer.cornerRadius = 12
        }
        
        cardImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .clear
        }
        
        stateLabel.do {
            $0.textColor = .grayscale300
            $0.textAlignment = .center
            $0.font = FontManager.body6R14.font
        }
        
        setBlurEffect()
    }
    
    override func setUI() {
        backgroundView.addSubviews(cardImageView, stateLabel)
        addSubview(backgroundView)
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.width.equalTo(101.adjustedW)
            $0.height.equalTo(152.adjustedH)
        }
        
        cardImageView.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.top).offset(15.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(73.adjustedW)
            $0.height.equalTo(100.adjustedH)
        }
        
        stateLabel.snp.makeConstraints {
            $0.top.equalTo(cardImageView.snp.bottom).offset(4.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(80.adjustedW)
            $0.height.equalTo(18.adjustedH)
        }
    }
    
    private func updateCard() {
        onSelected?()
        
        if isSelected {
            stateLabel.textColor = .primary300
            backgroundView.layer.borderWidth = 2
            backgroundView.layer.borderColor = UIColor.primary300.cgColor
        } else {
            stateLabel.textColor = .grayscale300
            backgroundView.layer.borderWidth = 0
        }
    }
}
