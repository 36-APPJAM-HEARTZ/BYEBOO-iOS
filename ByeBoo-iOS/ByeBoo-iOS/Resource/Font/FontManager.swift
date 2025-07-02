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
    case head1_sb_24
    case head2_m_22
    
    case sub1_sb_20
    case sub2_sb_18
    case sub3_m_18
    case sub4_r_18
    
    case body1_sb_16
    case body2_m_16
    case body3_r_16
    case body4_sb_14
    case body5_r_14
    
    case cap1_m_12
    case cap2_r_12
    
    public var fontProperty: FontProperty {
        switch self {
        case .head1_sb_24:
            return FontProperty(font: .semibold, size: 24, lineHeight: 130, kern: -1)
        case .head2_m_22:
            return FontProperty(font: .medium, size: 22, lineHeight: 120, kern: -1)
            
        case .sub1_sb_20:
            return FontProperty(font: .semibold, size: 20, lineHeight: 120, kern: -1)
        case .sub2_sb_18:
            return FontProperty(font: .semibold, size: 18, lineHeight: 120, kern: -1)
        case .sub3_m_18:
            return FontProperty(font: .medium, size: 18, lineHeight: 120, kern: -1)
        case .sub4_r_18:
            return FontProperty(font: .regular, size: 18, lineHeight: 120, kern: -1)
            
        case .body1_sb_16:
            return FontProperty(font: .semibold, size: 16, lineHeight: 130, kern: -1)
        case .body2_m_16:
            return FontProperty(font: .medium, size: 16, lineHeight: 130, kern: -1)
        case .body3_r_16:
            return FontProperty(font: .regular, size: 16, lineHeight: 130, kern: -1)
        case .body4_sb_14:
            return FontProperty(font: .semibold, size: 14, lineHeight: 130, kern: -1)
        case .body5_r_14:
            return FontProperty(font: .regular, size: 14, lineHeight: 130, kern: -1)
            
        case .cap1_m_12:
            return FontProperty(font: .medium, size: 12, lineHeight: 130, kern: -1)
        case .cap2_r_12:
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
}
