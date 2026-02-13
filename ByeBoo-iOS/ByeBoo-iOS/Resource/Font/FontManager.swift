//
//  FontManager.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/3/25.
//

import UIKit

public struct FontProperty {
    let font: UIFont.FontType
    let size: CGFloat
    let lineHeight: CGFloat?
    let kern: CGFloat
}

public enum FontManager {
    case head1M24
    case head2M22
    
    case sub1Sb20
    case sub2Sb18
    case sub3M18
    case sub4R18
    
    case body1Sb16
    case body2M16
    case body3R16
    case body4Sb14
    case body5M14
    case body6R14
    
    case cap1M12
    case cap2R12
    
    public var fontProperty: FontProperty {
        switch self {
        case .head1M24:
            return FontProperty(font: .medium, size: 24, lineHeight: 130, kern: -1)
        case .head2M22:
            return FontProperty(font: .medium, size: 22, lineHeight: 120, kern: -1)
            
        case .sub1Sb20:
            return FontProperty(font: .semibold, size: 20, lineHeight: 120, kern: -1)
        case .sub2Sb18:
            return FontProperty(font: .semibold, size: 18, lineHeight: 120, kern: -1)
        case .sub3M18:
            return FontProperty(font: .medium, size: 18, lineHeight: 120, kern: -1)
        case .sub4R18:
            return FontProperty(font: .regular, size: 18, lineHeight: 120, kern: -1)
            
        case .body1Sb16:
            return FontProperty(font: .semibold, size: 16, lineHeight: 130, kern: -1)
        case .body2M16:
            return FontProperty(font: .medium, size: 16, lineHeight: 130, kern: -1)
        case .body3R16:
            return FontProperty(font: .regular, size: 16, lineHeight: 150, kern: -1)
        case .body4Sb14:
            return FontProperty(font: .semibold, size: 14, lineHeight: 150, kern: -1)
        case .body5M14:
            return FontProperty(font: .medium, size: 14, lineHeight: 130, kern: -1)
        case .body6R14:
            return FontProperty(font: .regular, size: 14, lineHeight: 150, kern: -1)
            
        case .cap1M12:
            return FontProperty(font: .medium, size: 12, lineHeight: 130, kern: -1)
        case .cap2R12:
            return FontProperty(font: .regular, size: 12, lineHeight: 130, kern: -1)
            
        }
    }
}

public extension FontManager {
    var font: UIFont {
        guard let font = UIFont(name: fontProperty.font.name, size: fontProperty.size) else {
            return UIFont()
        }
        return font
    }
    
    var lineHeight: CGFloat? {
        guard let lineHeightPercent = fontProperty.lineHeight else { return nil }
        return fontProperty.size * (lineHeightPercent / 100.0)
    }
}
