//
//  ByeBooEmotionChip.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/7/25.
//

import UIKit

import SnapKit
import Then

final class ByeBooEmotionChip: BaseView {
    private let emotionImage: UIImageView
    let emotionTag: ByeBooFilledTag
    let emotionType: ByeBooEmotion
    
    init(emotionType: ByeBooEmotion, isPurple: Bool = false) {
        self.emotionImage = emotionType.emotionImage
        
        if isPurple == true {
            self.emotionTag = ByeBooFilledTag(tagType: .largePurple, text: emotionType.emotionText)
        } else {
            self.emotionTag = ByeBooFilledTag(tagType: .largeGray, text: emotionType.emotionText)
        }
        
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
        emotionImage.do {
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = true
        }
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(84.adjustedW)
            $0.height.equalTo(108.adjustedH)
        }
        
        emotionImage.snp.makeConstraints {
            $0.width.equalTo(84.adjustedW)
            $0.height.equalTo(76.adjustedH)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        emotionTag.snp.makeConstraints {
            $0.top.equalTo(emotionImage.snp.bottom).offset(8.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(84.adjustedW)
        }
    }
}
