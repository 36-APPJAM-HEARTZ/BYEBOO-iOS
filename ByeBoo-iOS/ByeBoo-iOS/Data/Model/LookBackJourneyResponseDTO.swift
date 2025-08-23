//
//  LookBackJourneyResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/20/25.
//

struct LookBackJourneyResponseDTO: Decodable{
    let inCompletedCount: Int
    let inCompletedJourneys: [JourneyStyleData]
    let completedCount: Int
    let completedJourneys: [JourneyStyleData]
}

struct JourneyStyleData: Decodable {
    let journey: String
    let style: String
}

extension LookBackJourneyResponseDTO {
    func toEntity() -> LookBackJourneyEntity {
        .init(
            inCompletedCount: inCompletedCount,
            inCompletedJourneys: inCompletedJourneys.map { $0.toEntity() },
            completedCount: completedCount,
            completedJourneys: completedJourneys.map { $0.toEntity() }
        )
    }
}

extension JourneyStyleData {
    func toEntity() -> JourneyEntity {
        .init(
            title: journey,
            description: style
        )
    }
}
