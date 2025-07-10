//
//  UserResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import Foundation

struct UserResponseDTO: Decodable {
    let userID: Int
    let name: String
}

extension UserResponseDTO {
    func toEntity() -> UserEntity {
        return .init(
            userID: self.userID,
            name: self.name
        )
    }
}
