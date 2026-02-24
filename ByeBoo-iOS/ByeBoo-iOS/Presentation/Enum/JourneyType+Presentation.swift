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
        case .face:
            "재회 준비"
        case .process:
            "이별 극복"
        }
    }
    
    var image: UIImage {
        switch self {
        case .face:
                .faceEmotion
        case .process:
                .processEmotion
        }
    }
    
    var description: String {
        return "\(title) 여정"
    }
    
    var frontImage: UIImage {
        switch self {
        case .face:
                .reunionFront
        case .process:
                .overcomingFront
        }
    }
    
    var backImage: UIImage {
        switch self {
        case .face:
                .reunionBack
        case .process:
                .overcomingBack
        }
    }
    
    static func titleToEnum(_ title: String) -> Self? {
        return Self.allCases.first { $0.title == title || $0.description == title }
    }
}
