//
//  ByeBooEmotion.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/11/25.
//

import UIKit

enum ByeBooEmotion: CaseIterable {
    case neutral
    case selfUnderstanding
    case sad
    case relieved
    
    var key: String {
        switch self {
        case .neutral:
            return "NEURTRAl"
        case .sad:
            return "SAD"
        case .selfUnderstanding:
            return "SELF_UNDERSTANDING"
        case .relieved:
            return "RELIEVED"
        }
    }
    
    var emotionImage: UIImageView {
        switch self {
        case .neutral:
            return UIImageView(image: .neutral)
        case .sad:
            return UIImageView(image: .emotionSad)
        case .selfUnderstanding:
            return UIImageView(image: .selfUnderstanding)
        case .relieved:
            return UIImageView(image: .relieved)
        }
    }
    
    var emotionText: String {
        switch self {
        case .neutral:
            return "그저그런"
        case .sad:
            return "슬픈"
        case .selfUnderstanding:
            return "자기이해"
        case .relieved:
            return "후련함"
        }
    }
    
    static func toEmotion(text: String) -> ByeBooEmotion {
        switch text {
        case "그저그런": return .neutral
        case "슬픈": return .sad
        case "자기이해": return .selfUnderstanding
        case "후련함": return .relieved
        default: return .neutral
        }
    }
}
