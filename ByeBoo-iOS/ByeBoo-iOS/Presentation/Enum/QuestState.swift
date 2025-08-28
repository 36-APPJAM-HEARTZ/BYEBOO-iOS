//
//  QuestState.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/18/25.
//

import UIKit

enum QuestState {
    
    case completed, ongoing, upComing, locked
    
    var backgroundColor: UIColor {
        switch self {
        case .completed, .locked:
            return .white10
        case .ongoing:
            return .primary30020
        case .upComing:
            return .secondary300
        }
    }
    
    var questNumberColor: UIColor {
        switch self {
        case .completed:
            return .white50
        case .ongoing:
            return .primary300
        case .upComing:
            return .secondary300
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
        case .upComing:
            return UIColor.secondary300.cgColor
        }
    }
    
    var strokeWidth: CGFloat {
        switch self {
        case .ongoing, .upComing:
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
        case .locked, .upComing:
            return .lock.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var timeText: String? {
        switch self {
        case .upComing(let time):
            return time
        case .completed, .ongoing, .locked:
            return nil
        }
    }
}
