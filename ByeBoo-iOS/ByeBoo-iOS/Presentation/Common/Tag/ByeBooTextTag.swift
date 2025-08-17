//
//  ByeBooTag.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/4/25.
//

import UIKit

import SnapKit

enum TextTagType {
    case yellow
    case gray
    
    var textColor: UIColor {
        switch self {
        case .yellow:
            return .secondary300
        case .gray:
            return .grayscale500
        }
    }
}

final class ByeBooTextTag: UILabel {
    init(type: TextTagType, text: String) {
        super.init(frame: .zero)
        self.text = text
        self.font = FontManager.cap1M12.font
        self.textColor = type.textColor
        self.textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateText(_ text: String) {
        self.text = text
    }
}
