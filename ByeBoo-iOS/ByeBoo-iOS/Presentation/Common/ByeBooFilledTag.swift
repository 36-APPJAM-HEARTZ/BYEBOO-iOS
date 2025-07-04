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
    
    var backgroundColor: UIColor {
        switch self {
        case .purple:
            return .primary300
        case .gray:
            return .white10
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .purple:
            return .white
        case .gray:
            return .grayscale300
        }
    }
}

final class ByeBooFilledTag: BaseView {
    private let textLabel =  UILabel()
    private var tagType: ByeBooFilledTagType
    
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
            $0.font = FontManager.cap1M12.font
            $0.textColor = tagType.textColor
        }
    }
    
    override func setUI() {
        addSubview(textLabel)
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
        textLabel.snp.makeConstraints {
            //TODO: - 기기대응 extension 적용
            $0.leading.trailing.equalToSuperview().inset(17.5)
            $0.top.bottom.equalToSuperview().inset(3)
        }
    }
}
