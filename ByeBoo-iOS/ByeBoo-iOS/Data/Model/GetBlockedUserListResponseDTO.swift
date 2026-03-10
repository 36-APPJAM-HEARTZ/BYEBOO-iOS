//
//  GetBlockedUserListResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/9/26.
//

import Foundation

struct GetBlockedUserListResponseDTO: Decodable {
    let blockList: [BlockedUserResponseDTO]
}

struct BlockedUserResponseDTO: Decodable {
    let blockId: Int
    let name: String
}

extension GetBlockedUserListResponseDTO {
    func toEntity() -> [BlockedUserEntity] {
        return blockList.map { $0.toEntity() }
    }
}

extension BlockedUserResponseDTO {
    func toEntity() -> BlockedUserEntity {
        return .init(blockID: blockId, name: name)
    }
}
