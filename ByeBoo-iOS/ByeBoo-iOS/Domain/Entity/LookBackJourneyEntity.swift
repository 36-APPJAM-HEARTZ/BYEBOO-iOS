//
//  LookBackJourneyEntity.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/20/25.
//

struct LookBackJourneyEntity {
    let inCompletedCount: Int
    let inCompletedJourneys: [JourneyStyleEntity]
    let completedCount: Int
    let completedJourneys: [JourneyStyleEntity]
}

struct JourneyStyleEntity {
    let journey: String
    let style: String
}

extension LookBackJourneyEntity {
    static func stub() -> LookBackJourneyEntity {
        return .init(
            inCompletedCount: 1,
            inCompletedJourneys: JourneyStyleEntity.stub(),
            completedCount: 1,
            completedJourneys: JourneyStyleEntity.stub()
        )
    }
}

extension JourneyStyleEntity {
    static func stub() -> [JourneyStyleEntity] {
        return [
            JourneyStyleEntity(journey: "감정 정리", style: "ACTIVE"),
            JourneyStyleEntity(journey: "감정 직면", style: "RECORDING"),
        ]
    }
}
