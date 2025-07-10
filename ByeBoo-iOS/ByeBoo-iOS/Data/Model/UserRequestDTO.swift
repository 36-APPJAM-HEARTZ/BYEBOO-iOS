//
//  UserRequestDTO.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import Foundation

struct UserRequestDTO: Encodable {
    let nickname: Int
    let emotion: String
    let quest: String
}
