//
//  QuestCardType.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/18/25.
//

import UIKit

enum QuestCardType {
    case start
    case lookBack
    
    var title: String {
        switch self {
        case .start:
            "새로운 이별 극복 여정\n시작하기"
        case .lookBack:
            "내가 완료한 여정\n돌아보기"
        }
    }
    
    var character: UIImage {
        switch self {
        case .start:
                .newJourney
        case .lookBack:
                .completeJourney
        }
    }
}
