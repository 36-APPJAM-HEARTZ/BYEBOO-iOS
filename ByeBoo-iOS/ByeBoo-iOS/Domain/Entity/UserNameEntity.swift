//
//  UserNameEntity.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/24/25.
//

struct UserNameEntity {
    let name: String
}

extension UserNameEntity {
    static func stub(name: String) -> UserNameEntity {
        return .init(name: name)
    }
}
