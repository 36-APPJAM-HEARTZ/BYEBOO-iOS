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
            titleLabel?.font = style.font
            titleLabel?.textColor = color
            let targetText = text ?? title(for: state)
            
            guard let lineHeight = style.lineHeight else {
                setTitle(targetText, for: state)
                return
            }
            
            guard let targetText else { return }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight
            
            var attributes: [NSAttributedString.Key: Any] = [
                .font: style.font,
                .paragraphStyle: paragraphStyle,
                .baselineOffset: (lineHeight - style.font.lineHeight) / 2,
                .kern: style.fontProperty.kern
            ]
            
            if let titleColor = titleColor(for: state) {
                attributes[.foregroundColor] = titleColor
            }
            
            setAttributedTitle(NSAttributedString(string: targetText, attributes: attributes), for: state)
        }
}
