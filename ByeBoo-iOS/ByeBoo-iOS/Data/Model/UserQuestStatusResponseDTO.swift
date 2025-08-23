//
//  UserQuestStatusResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/14/25.
//

struct UserQuestStatusResponseDTO: Decodable {
    let todayComplete: Bool
    let count: Int
    let userCurrentStatus: HomeStateData
}

extension UserQuestStatusResponseDTO {
    func toEntity() -> UserQuestStatusEntity {
        return .init(
            todayComplete: todayComplete,
            currentStatus: HomeState.toHomeState(userCurrentStatus),
            questCount: count
        )
    }
}
