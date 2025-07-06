//
//  UIFont+.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/3/25.
//

import UIKit

extension UIFont {
    enum FontType: String {
        case bold = "SUIT-Bold"
        case extrabold = "SUIT-ExtraBold"
        case extralight = "SUIT-ExtraLight"
        case heavy = "SUIT-Heavy"
        case light = "SUIT-Light"
        case medium = "SUIT-Medium"
        case regular = "SUIT-Regular"
        case semibold = "SUIT-Semibold"
        case thin = "SUIT-Thin"
        
        var name: String {
            return self.rawValue
        }
        
        static func font(_ type: FontType, ofsize size: CGFloat) -> UIFont {
            return UIFont(name: type.rawValue, size: size.adjustedW)!
        }
    }

}
