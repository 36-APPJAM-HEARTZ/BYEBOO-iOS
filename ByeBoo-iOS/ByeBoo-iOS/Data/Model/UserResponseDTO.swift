//
//  UserResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import Foundation

struct UserResponseDTO: Decodable {
    let id: Int
    let name: String
}

extension UserResponseDTO {
    func toEntity() -> UserEntity {
        return .init(
            id: self.id,
            name: self.name
        )
    }
}
