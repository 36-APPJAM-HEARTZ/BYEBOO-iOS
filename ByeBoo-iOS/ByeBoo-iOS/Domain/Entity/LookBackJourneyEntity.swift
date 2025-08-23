//
//  LookBackJourneyEntity.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/20/25.
//

struct LookBackJourneyEntity {
    let inCompletedCount: Int
    let inCompletedJourneys: [JourneyEntity]
    let completedCount: Int
    let completedJourneys: [JourneyEntity]
}

extension LookBackJourneyEntity {
    static func stub() -> LookBackJourneyEntity {
        return .init(
            inCompletedCount: 1,
            inCompletedJourneys: [JourneyEntity.stub()],
            completedCount: 1,
            completedJourneys: [JourneyEntity.stub()]
        )
    }
}
