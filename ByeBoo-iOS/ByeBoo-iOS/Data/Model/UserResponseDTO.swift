//
//  UserResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import Foundation

struct UserResponseDTO: Decodable {
    let name: String
    let birth: String
}

extension UserResponseDTO {
    func toEntity() -> TestEntity {
        return .init(
            name: self.name,
            birth: self.birth
        )
    }
    
    func stub() -> TestEntity {
        return .init(name: "주리", birth: "001205")
    }
}
