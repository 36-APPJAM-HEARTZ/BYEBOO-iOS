//
//  UILabel+.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

extension UILabel {
    func underLine(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            .baselineOffset: 3
        ], range: NSString(string: text).range(of: text))
        self.attributedText = attributedString
    }
    
    func applyByeBooFont(
        style: FontManager,
        text: String? = nil,
        color: UIColor,
        textAlignment: NSTextAlignment? = nil,
        numberOfLines: Int? = nil
    ) {
        if let text { self.text = text }
        self.textColor = color
        if let textAlignment { self.textAlignment = textAlignment }
        if let numberOfLines { self.numberOfLines = numberOfLines }
        
        font = style.font
        let targetText = text ?? self.text
        
        guard let targetText else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = style.lineHeight
        paragraphStyle.maximumLineHeight = style.lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: (style.lineHeight - style.font.lineHeight) / 2,
            .foregroundColor: textColor as Any,
            .kern: style.kern
        ]
        
        attributedText = NSAttributedString(string: targetText, attributes: attributes)
    }
}
