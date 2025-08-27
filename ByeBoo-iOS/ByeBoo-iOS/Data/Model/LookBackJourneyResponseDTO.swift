//
//  LookBackJourneyResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/20/25.
//

struct LookBackJourneyResponseDTO: Decodable{
    let inCompletedCount: Int
    let inCompletedJourneys: [JourneyTypeData]
    let completedCount: Int
    let completedJourneys: [JourneyTypeData]
}

struct JourneyTypeData: Decodable {
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

extension JourneyTypeData {
    // TODO: 교체
    func toEntity() -> JourneyEntity {
        .init(
            title: self.journey,
            description: nil,
            style: SelectQuestType.keyToEnum(self.style)
        )
    }
}
