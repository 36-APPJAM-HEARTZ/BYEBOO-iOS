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
}
