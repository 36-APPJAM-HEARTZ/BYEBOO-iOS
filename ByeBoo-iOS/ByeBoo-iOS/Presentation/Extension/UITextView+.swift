//
//  UITextView+.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 2/13/26.
//

import Foundation
import UIKit

extension UITextView {
    func applyByeBooFont(
        style: FontManager,
        text: String? = nil,
        color: UIColor
    ) {
        font = style.font
        let targetText = text ?? self.text
        self.textColor = color
        
        guard let targetText else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = style.lineHeight
        paragraphStyle.maximumLineHeight = style.lineHeight
        
        var attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: (style.lineHeight - style.font.lineHeight) / 2,
            .kern: style.kern
        ]
        
        if let textColor = textColor {
            attributes[.foregroundColor] = textColor
        }
        
        attributedText = NSAttributedString(string: targetText, attributes: attributes)
        typingAttributes = attributes
    }
}
