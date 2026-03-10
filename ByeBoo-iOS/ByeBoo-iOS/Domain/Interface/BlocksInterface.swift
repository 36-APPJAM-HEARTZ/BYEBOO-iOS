//
//  BlocksInterface.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/5/26.
//

protocol BlocksInterface {
    func blockUser(userID: Int) async throws
    func deleteBlockedUser(blockID: Int) async throws
    func getBlockedUsersList() async throws -> [BlockedUserEntity]
}
