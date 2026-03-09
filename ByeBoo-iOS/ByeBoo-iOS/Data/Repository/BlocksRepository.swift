//
//  BlocksRepository.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/5/26.
//

import Foundation

struct DefaultBlocksRepository: BlocksInterface {
    
    private let networkService: NetworkService
    
    init(
        networkService: NetworkService
    ) {
        self.networkService = networkService
    }
    
    func blockUser(userID: Int) async throws {
        try await networkService.request(BlocksAPI.blockUser(userID: userID))
    }
    
    func deleteBlockedUser(blockID: Int) async throws {
        try await networkService.request(BlocksAPI.deleteBlockedUser(userID: blockID))
    }
    
    func getBlockedUsersList() async throws -> [BlockedUserEntity] {
        let blockList = try await networkService.request(
            BlocksAPI.getBlockList,
            decodingType: GetBlockedUserListResponseDTO.self
        )
        return blockList.toEntity()
    }
}
