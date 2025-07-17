//
//  UIFont+.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/3/25.
//

import UIKit

extension UIFont {
    enum FontType: String {
        case bold = "PretendardT-Bold"
        case extrabold = "Pretendard-ExtraBold"
        case extralight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
        case semibold = "Pretendard-Semibold"
        case thin = "Pretendard-Thin"
        
        var name: String {
            return self.rawValue
        }
        
        static func font(_ type: FontType, ofsize size: CGFloat) -> UIFont {
            return UIFont(name: type.rawValue, size: size.adjustedW)!
        }
    }

}
