//
//  ByeBooEmotionChip.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/7/25.
//

import UIKit

import SnapKit
import Then

enum ByeBooEmotion: CaseIterable {
    case neutral
    case selfUnderstanding
    case sad
    case relieved
    
    var key: String {
        switch self {
        case .neutral:
            return "NEURTRAl"
        case .sad:
            return "SAD"
        case .selfUnderstanding:
            return "SELF_UNDERSTANDING"
        case .relieved:
            return "RELIEVED"
        }
    }
    
    var emotionImage: UIImageView {
        switch self {
        case .neutral:
            return UIImageView(image: .neutral)
        case .sad:
            return UIImageView(image: .sad)
        case .selfUnderstanding:
            return UIImageView(image: .selfUnderstanding)
        case .relieved:
            return UIImageView(image: .relieved)
        }
    }
    
    var emotionText: String {
        switch self {
        case .neutral:
            return "그저그런"
        case .sad:
            return "슬픈"
        case .selfUnderstanding:
            return "자기이해"
        case .relieved:
            return "후련함"
        }
    }
}

final class ByeBooEmotionChip: BaseView {
    private let emotionImage: UIImageView
    let emotionTag: ByeBooFilledTag
    let emotionType: ByeBooEmotion

    init(emotionType: ByeBooEmotion) {
        self.emotionImage = emotionType.emotionImage
        self.emotionTag = ByeBooFilledTag(tagType: .largeGray, text: emotionType.emotionText)
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
