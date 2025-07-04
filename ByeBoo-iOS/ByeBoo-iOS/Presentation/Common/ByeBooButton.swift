//
//  ByeBooButton.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/4/25.
//

import UIKit

import SnapKit

enum ByeBooButtonType {
    case sub
    case outline
    case enabled
    case disabled
    case disabled2
    
    var backgroundColor: UIColor {
        switch self {
        case .sub:
                .primary50
        case .outline:
                .clear
        case .enabled:
                .primary300
        case .disabled:
                .white10
        case .disabled2:
                .black50
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .sub:
                .primary300
        case .outline:
                .grayscale200
        case .enabled:
                .white
        case .disabled:
                .grayscale300
        case .disabled2:
                .grayscale400
        }
    }
    
    var borderColor: CGColor? {
        switch self {
        case .outline:
            UIColor(resource: .grayscale400).cgColor
        default:
            UIColor(.clear).cgColor
        }
    }
}

final class ByeBooButton: UIButton {
    private let titleText: String
    private let type: ByeBooButtonType
    
    init(
        titleText: String,
        type: ByeBooButtonType
    ) {
        self.titleText = titleText
        self.type = type
        
        super.init(frame: .zero)
        
        self.setTitle(titleText, for: .normal)
        self.setTitleColor(type.textColor, for: .normal)
        self.backgroundColor = type.backgroundColor
        self.layer.borderWidth = 1
        self.layer.borderColor = type.borderColor
        self.layer.cornerRadius = 12
        
        self.snp.makeConstraints {
            $0.height.equalTo(53.adjustedH)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
