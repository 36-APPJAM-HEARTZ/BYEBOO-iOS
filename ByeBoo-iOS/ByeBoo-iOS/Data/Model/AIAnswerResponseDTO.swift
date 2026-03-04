//
//  AIAnswerResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 3/4/26.
//

struct AIAnswerResponseDTO: Decodable {
    let aiAnswer: String
}

extension AIAnswerResponseDTO {
    func toEntity() -> AIAnswerEntity {
        return .init(AIAnswer: aiAnswer)
    }
}
