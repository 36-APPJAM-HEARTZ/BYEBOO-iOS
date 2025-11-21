//
//  DialogueResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/14/25.
//

struct DialogueResponseDTO: Decodable {
    let dialogue: String
    let tapDialogue: String
}

extension DialogueResponseDTO {
    func toEntity() -> DialogueEntity {
        return .init(
            dialogue: dialogue,
            tapDialogue: tapDialogue
        )
    }
}
