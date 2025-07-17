//
//  JourneyType.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/18/25.
//

import UIKit

enum JourneyType: String {
    case face = "감정 직면"
    case process = "감정 정리"
    
    var image: UIImage {
        switch self {
        case .face:
                .faceEmotion
        case .process:
                .processEmotion
        }
    }
    
    var description: String {
        return "\(rawValue) 여정"
    }
    
    var frontImage: UIImage {
        switch self {
        case .face:
                .faceFrontCard
        case .process:
                .processFrontCard
        }
    }
    
    var backImage: UIImage {
        switch self {
        case .face:
                .faceBackCard
        case .process:
                .processBackCard
        }
    }
}
