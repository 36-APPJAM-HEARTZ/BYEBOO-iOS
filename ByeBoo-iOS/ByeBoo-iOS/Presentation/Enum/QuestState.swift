//
//  QuestState.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/18/25.
//

import UIKit

enum QuestState {
    
    case completed, ongoing, locked
    
    var backgroundColor: UIColor {
        switch self {
        case .completed, .locked:
            return .white10
        case .ongoing:
            return .primary30020
        }
    }
    
    var questNumberColor: UIColor {
        switch self {
        case .completed:
            return .white50
        case .ongoing:
            return .primary300
        case .locked:
            return .white10
        }
    }
    
    var strokeColor: CGColor {
        switch self {
        case .ongoing:
            return UIColor.primary300.cgColor
        case .completed, .locked:
            return UIColor.clear.cgColor
        }
    }
    
    var strokeWidth: CGFloat {
        switch self {
        case .ongoing:
            return 1
        case .completed, .locked:
            return 0
        }
    }
    
    var image: UIImage {
        switch self {
        case .completed:
            return .boriStamp
        case .ongoing:
            return .travel
        case .locked:
            return .lock.withRenderingMode(.alwaysTemplate)
        }
    }
}
