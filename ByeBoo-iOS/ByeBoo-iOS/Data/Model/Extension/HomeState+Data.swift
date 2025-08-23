//
//  HomeState+.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 8/21/25.
//

extension HomeState {
    static func toHomeState(_ data: HomeStateData) -> HomeState {
        switch data {
        case .INITIAL_START_STATUS: return .beforeJourneyStart
        case .TODAY_NOT_COMPLETED_STATUS: return .beforeQuest
        case .TODAY_COMPLETED_STATUS: return .afterQuest
        case .JOURNEY_COMPLETED_STATUS: return .afterJourney
        }
    }
}

enum HomeStateData: String, Decodable {
    case INITIAL_START_STATUS
    case TODAY_NOT_COMPLETED_STATUS
    case TODAY_COMPLETED_STATUS
    case JOURNEY_COMPLETED_STATUS
}
