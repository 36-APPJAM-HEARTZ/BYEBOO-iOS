//
//  ByeBooTag.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/4/25.
//

import UIKit

import SnapKit

final class ByeBooYellowTag: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        self.font = FontManager.cap1M12.font
        self.textColor = .secondary300
        self.textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateText(_ text: String) {
        self.text = text
    }
}
