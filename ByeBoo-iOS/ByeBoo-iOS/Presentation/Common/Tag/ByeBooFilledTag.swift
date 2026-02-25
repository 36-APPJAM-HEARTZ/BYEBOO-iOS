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
    case largePurple
    case largeGray
    case word3Purple
    case word3Gray
    case smallPurple
    case smallGray
    case yelloFilled
    
    var backgroundColor: UIColor {
        switch self {
        case .largePurple, .word3Purple, .smallPurple:
            return .primary300
        case .largeGray, .word3Gray, .smallGray :
            return .white5
        case .yelloFilled:
            return .secondary30010
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .largePurple, .word3Purple, .smallPurple:
            return .white
        case .word3Gray, .smallGray, .largeGray:
            return .grayscale300
        case .yelloFilled:
            return .secondary300
        }
    }
    
    var font: UIFont {
        switch self {
        case .largePurple, .largeGray:
            return FontManager.body4Sb14.font
        case .yelloFilled, .word3Purple, .word3Gray, .smallPurple, .smallGray:
            return FontManager.cap1M12.font
        }
    }
    
    var verticalInset: CGFloat {
        switch self {
        case .largePurple, .largeGray:
            return 3.adjustedH
        case .word3Purple, .word3Gray, .smallPurple, .smallGray, .yelloFilled:
            return 4.adjustedH
        }
    }
    
    var horizontalInset: CGFloat {
        switch self {
        case .largePurple, .largeGray,.smallPurple, .smallGray, .yelloFilled:
            return 17.5.adjustedW
        case .word3Purple, .word3Gray:
            return 12.adjustedW
        }
    }
}

final class ByeBooFilledTag: BaseView {
    var textLabel =  UILabel()
    private var tagType: ByeBooFilledTagType
    var isSelected: Bool = false {
        didSet { toggleTagType() }
    }
    
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
            $0.isUserInteractionEnabled = true
        }
        
        textLabel.do {
            $0.font = tagType.font
            $0.textColor = tagType.textColor
            $0.textAlignment = .center
            $0.isUserInteractionEnabled = false
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
            $0.leading.trailing.equalToSuperview().inset(tagType.horizontalInset)
            $0.top.bottom.equalToSuperview().inset(tagType.verticalInset)
        }
    }
    
    func toggleTagType() {
        switch tagType {
        case .largePurple, .largeGray:
            tagType = isSelected ? .largePurple: .largeGray
        case .word3Purple, .word3Gray:
            tagType = isSelected ? .word3Purple : .word3Gray
        case .smallPurple, .smallGray:
            tagType = isSelected ? .smallPurple : .smallGray
        default:
            break
       }
        setStyle()
    }
    
    func updateText(_ text: String) {
        self.textLabel.text = text
    }
}
