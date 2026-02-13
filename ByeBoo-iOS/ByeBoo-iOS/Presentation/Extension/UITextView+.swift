//
//  UITextView+.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 2/13/26.
//

import Foundation
import UIKit

extension UITextView {
    func applyTextStyle(
        style: FontManager,
        text: String? = nil,
        color: UIColor
    ) {
        font = style.font
        let targetText = text ?? self.text
        self.textColor = color
        
        guard let lineHeight = style.lineHeight else {
            self.text = targetText
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
        
        if let textColor = textColor {
            attributes[.foregroundColor] = textColor
        }
        
        attributedText = NSAttributedString(string: targetText, attributes: attributes)
        typingAttributes = attributes
    }
}
