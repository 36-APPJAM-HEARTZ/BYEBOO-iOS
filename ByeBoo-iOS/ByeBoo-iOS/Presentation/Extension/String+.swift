//
//  String+.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/5/25.
//

import UIKit

extension String {
    
    var isValidNickname: Bool {
        let regularExpression = "(?=.{2,5}$)(?!.*[ㄱ-ㅎㅏ-ㅣ])[가-힣a-zA-Z0-9]+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: self)
    }
    
    func trim(limit: Int) -> String {
        return String(self.prefix(limit))
    }
    
    func makeTitle(
        rangedText: String,
        font: UIFont? = nil,
        baseFont: UIFont? = nil,
        originalTitleColor: UIColor? = nil
    ) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        attributedString.addAttribute(
            .foregroundColor,
            value: originalTitleColor ?? UIColor.grayscale50,
            range: NSRange(location: 0, length: self.count)
        )
        if let baseFont = baseFont {
            attributedString.addAttribute(
                .font,
                value: baseFont,
                range: NSRange(location: 0, length: self.count)
            )
        }
        
        let range = (self as NSString).range(of: rangedText)
        if range.location != NSNotFound {
            if let font = font {
                attributedString.addAttribute(.font, value: font, range: range)
            }
            attributedString.addAttribute(.foregroundColor, value: UIColor.primary300, range: range)
        }
        
        return attributedString
    }
    
    func dateFormat() -> String {
        let components = self.split(separator: "-")
        return components.joined(separator: ". ") + "."
    }
    
    func canBeRendered(by font: UIFont) -> Bool {
        let cfFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        return CTFontGetGlyphWithName(cfFont, self as CFString) != 0
    }
}
