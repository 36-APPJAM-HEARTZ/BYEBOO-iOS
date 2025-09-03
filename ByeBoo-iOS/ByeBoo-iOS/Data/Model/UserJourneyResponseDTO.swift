//
//  UserJourneyResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

struct UserJourneyResponseDTO: Decodable {
    let journey: String
    let description: String?
}

extension UserJourneyResponseDTO {
    func toEntity() -> JourneyEntity {
        return .init(
            title: self.journey,
            description: self.description,
            style: nil,
            questType: nil
        )
    }
}
