//
//  ByeBooTipTag.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 2/13/26.
//

import UIKit

import SnapKit
import Then

final class ByeBooTipTag: UIButton {
    
    init(text: String) {
        super.init(frame: .zero)
        
        setTitle(text, for: .normal)
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.do {
            $0.applyByeBooFont(
                style: .cap1M12,
                color: .primary200
            )
            $0.backgroundColor = .white5
            $0.layer.cornerRadius = 12.adjustedW
            $0.layer.borderColor = UIColor.grayscale800.cgColor
            $0.layer.borderWidth = 1
        }
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(76.adjustedW)
            $0.height.equalTo(24.adjustedH)
        }
    }
}
