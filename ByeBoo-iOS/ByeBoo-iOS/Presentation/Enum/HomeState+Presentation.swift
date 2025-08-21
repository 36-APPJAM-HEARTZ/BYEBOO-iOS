//
//  HomeState.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/18/25.
//

import UIKit

extension HomeState {
    var title: String {
        switch self {
        case .beforeJourneyStart:
            "여정 시작하기"
        case .beforeQuest:
            "오늘의 퀘스트 하러 가기"
        case .afterQuest:
            "오늘의 퀘스트 완료!"
        case .afterJourney:
            "새로운 이별 극복 여정 시작하기"
        }
    }
    
    var description: String {
        switch self {
        case .beforeJourneyStart:
            "제가 옆에서 함께할게요!"
        case .beforeQuest:
            "퀘스트를 하고나면 한층 더 성장할 거에요."
        case .afterQuest:
            "잘하셨어요! 내일 또 만나요."
        case .afterJourney:
            "다음 여정도, 제가 곁에서 함께할게요."
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .beforeJourneyStart, .beforeQuest, .afterJourney:
                .primary300
        case .afterQuest:
                .clear
        }
    }
    
    var hasProgress: Bool {
        switch self {
        case .beforeJourneyStart, .afterJourney:
            false
        case .beforeQuest, .afterQuest:
            true
        }
    }
}
