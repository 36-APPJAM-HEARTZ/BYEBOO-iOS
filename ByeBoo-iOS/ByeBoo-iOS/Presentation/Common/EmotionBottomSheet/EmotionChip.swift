//
//  ByeBooEmotionChip.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/7/25.
//

import UIKit

import SnapKit
import Then

enum EmotionChipState {
    case selected
    case unselected
    case defaultState
    
    var backgroundColor: UIColor {
        switch self {
        case .selected:
            return .primary30020
        case .unselected, .defaultState:
            return .white10
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .selected:
            return .primary200
        case .unselected:
            return .grayscale500
        case .defaultState:
            return .grayscale400
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .selected:
            return .primary300
        case .unselected, .defaultState:
            return .clear
        }
    }
    
    var backgroundOpacity: Float {
        switch self {
        case .selected, .defaultState:
            return 1
        case .unselected:
            return 0.5
        }
    }
}

final class ByeBooEmotionChip: BaseView {
    var chipState: EmotionChipState = .defaultState
    private var emotionImage: UIImageView
    var emotionTag = UILabel()
    var emotionType: ByeBooEmotion
    
    init(emotionType: ByeBooEmotion) {
        self.emotionImage = emotionType.emotionImage
        self.emotionTag.text = emotionType.emotionText
        self.emotionType = emotionType
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        addSubviews(emotionImage, emotionTag)
    }
    
    override func setStyle() {
        self.do {
            $0.layer.opacity = chipState.backgroundOpacity
            $0.layer.borderColor = chipState.borderColor.cgColor
            $0.layer.cornerRadius = 12.adjustedH
        }
        
        emotionImage.do {
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = true
        }
        
        emotionTag.do {
            $0.textAlignment = .center
            $0.textColor = chipState.textColor
            $0.font = FontManager.body4Sb14.font
        }
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(84.adjustedW)
            $0.height.equalTo(98.adjustedH)
        }
        
        emotionImage.snp.makeConstraints {
            $0.width.equalTo(56.adjustedW)
            $0.height.equalTo(56.adjustedH)
            $0.top.equalToSuperview().inset(8.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.bottom.equalTo(emotionTag.snp.top).offset(-8)
            $0.centerX.equalToSuperview()
        }
        
        emotionTag.snp.makeConstraints {
            $0.top.equalTo(emotionImage.snp.bottom).offset(8.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(84.adjustedW)
        }
    }
}

extension ByeBooEmotionChip {
    func updateEmotion(_ emotionType: ByeBooEmotion) {
        self.emotionType = emotionType
        self.emotionImage.image = emotionType.emotionImage.image
        self.emotionTag.text = emotionType.emotionText
    }
    
    func updateChipUI() {
        self.emotionTag.textColor = chipState.textColor
        self.backgroundColor = chipState.backgroundColor
        self.layer.borderColor = chipState.borderColor.cgColor
        self.layer.opacity = chipState.backgroundOpacity
        self.layer.borderWidth = chipState.borderColor == .clear ? 0 : 1
    }
}
