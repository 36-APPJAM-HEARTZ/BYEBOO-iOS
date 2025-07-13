//
//  UserEntity.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/9/25.
//

import Foundation

struct UserEntity {
    let id: Int
    let name: String
}

extension UserEntity {
    static func stub(name: String, feeling: String, questStyle: String) -> Self {
        return .init(id: 1, name: name)
    }
}
