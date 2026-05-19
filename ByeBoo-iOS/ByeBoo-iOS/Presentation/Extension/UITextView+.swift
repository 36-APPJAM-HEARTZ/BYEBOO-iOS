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
            .kern: style.kern
        ]
        
        if let textColor = textColor {
            attributes[.foregroundColor] = textColor
        }
        
        attributedText = NSAttributedString(string: targetText, attributes: attributes)
        typingAttributes = attributes
    }
    
    func applyTextViewStyle(style: FontManager, text: String, color: UIColor) {
        self.applyByeBooFont(
            style: style,
            text: text,
            color: color
        )
    }
    
    func numberOfLine() -> Int {
        guard !text.isEmpty else { return 0 }
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = sizeThatFits(size)

        let lineHeight: CGFloat
        if let paragraphStyle = attributedText?.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle,
           paragraphStyle.minimumLineHeight > 0 {
            lineHeight = paragraphStyle.minimumLineHeight
        } else if let font = attributedText?.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
            lineHeight = font.lineHeight
        } else {
            lineHeight = self.font?.lineHeight ?? 0
        }

        guard lineHeight > 0 else { return 0 }
        return Int(estimatedSize.height / lineHeight)
    }
}
