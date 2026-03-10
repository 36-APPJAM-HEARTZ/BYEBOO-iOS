//
//  JourneyType.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/18/25.
//

import UIKit

extension JourneyType {
    var title: String {
        switch self {
        case .recording:
            "이별 극복"
        case .active:
            "감정 정리"
        case .reunion:
            "재회 준비"
        }
    }
    
    var description: String {
        return "\(title) 여정"
    }
    
    var frontImage: UIImage? {
        switch self {
        case .recording:
            .overcomingFront
        case .reunion:
            .reunionFront
        case .active:
            nil
        }
    }
    
    var backImage: UIImage? {
        switch self {
        case .recording:
            .overcomingBack
        case .reunion:
            .reunionBack
        case .active:
            nil
        }
    }
    
    static func titleToEnum(_ title: String) -> Self? {
        return Self.allCases.first { $0.title == title || $0.description == title }
    }
}
