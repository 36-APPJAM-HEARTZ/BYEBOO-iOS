//
//  UserNameResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/25/25.
//

struct UserNameResponseDTO: Decodable {
    let name: String
}

extension UserNameResponseDTO {
    func toEntity() -> UserNameEntity {
        return .init(name: self.name)
    }
}
