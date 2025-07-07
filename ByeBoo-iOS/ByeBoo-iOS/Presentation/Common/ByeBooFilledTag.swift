//
//  ByeBoo.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/4/25.
//

import UIKit

import SnapKit
import Then

enum ByeBooFilledTagType {
    case purple
    case gray
    case emotionDisabled
    case emotionEnabled
    
    var backgroundColor: UIColor {
        switch self {
        case .purple, .emotionEnabled:
            return .primary300
        case .gray:
            return .white10
        case .emotionDisabled:
            return .white10
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .purple, .emotionEnabled:
            return .white
        case .gray:
            return .grayscale300
        case .emotionDisabled:
            return .grayscale50
        }
    }
    
    var font: UIFont {
        switch self {
        case .purple, .gray:
            return FontManager.cap1M12.font
        case .emotionDisabled, .emotionEnabled:
            return FontManager.body4Sb14.font
        }
    }
}

final class ByeBooFilledTag: BaseView {
    private let textLabel =  UILabel()
    private var tagType: ByeBooFilledTagType
    var isSelected: Bool = false {
        didSet { toggleTagType() }
    }
    var onToggle: (() -> Void)?
    
    
    init(tagType: ByeBooFilledTagType, text: String) {
        self.tagType = tagType
        super.init(frame: .zero)
        self.textLabel.text = text
        
        setStyle()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        self.do {
            $0.backgroundColor = tagType.backgroundColor
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        textLabel.do {
            $0.font = tagType.font
            $0.textColor = tagType.textColor
            $0.textAlignment = .center
        }
    }
    
    override func setUI() {
        addSubview(textLabel)
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(24.adjustedH)
        }
        
        textLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(17.5.adjustedW)
            $0.top.bottom.equalToSuperview().inset(3.adjustedH)
        }
    }
    
    func toggleTagType() {
        switch tagType {
           case .emotionEnabled, .emotionDisabled:
               tagType = isSelected ? .emotionEnabled : .emotionDisabled
           case .purple, .gray:
               tagType = isSelected ? .purple : .gray
       }
        setStyle()
    }
    
}
