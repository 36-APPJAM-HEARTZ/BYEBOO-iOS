//
//  UIButton+.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/6/25.
//

import UIKit

extension UIButton {
    
    func setUnderLine() {
        guard let title = title(for: .normal) else { return }
        
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: title.count)
        )
        
        setAttributedTitle(attributedString, for: .normal)
    }
    
    func applyByeBooFont(
        style: FontManager,
        text: String? = nil,
        color: UIColor,
        for state: UIControl.State = .normal) {
            let targetText = text ?? title(for: state)
            guard let targetText = targetText else { return }
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: style.font,
                .kern: style.kern,
                .foregroundColor: color
            ]
            
            setAttributedTitle(
                NSAttributedString(string: targetText, attributes: attributes),
                for: state
            )
        }
}
