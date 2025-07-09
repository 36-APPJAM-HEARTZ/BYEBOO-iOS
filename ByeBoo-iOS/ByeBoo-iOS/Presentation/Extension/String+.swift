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
    
    func makeTitle(rangedText: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.grayscale50,
            range: NSRange(location: 0, length: self.count)
        )
        
        let range = (self as NSString).range(of: rangedText)
        if range.location != NSNotFound {
            attributedString.addAttribute(
                .foregroundColor,
                value: UIColor.primary300,
                range: range
            )
        }
        
        return attributedString
    }

}
