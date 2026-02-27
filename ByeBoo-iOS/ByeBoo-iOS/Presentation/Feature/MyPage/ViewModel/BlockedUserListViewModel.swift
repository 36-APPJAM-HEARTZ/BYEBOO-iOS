//
//  BlockedUserListViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/23/26.
//

final class BlockedUserListViewModel {
    
    struct BlockedUserEntity {
        let blockID: Int
        let name: String
    }
    
    private var blockedUsers: [BlockedUserEntity] = []
    
    var blockedUsersCount: Int {
        blockedUsers.count
    }
    
    func getBlockedUsers() {
        blockedUsers = [
            .init(blockID: 1, name: "승준"),
            .init(blockID: 2, name: "주리"),
            .init(blockID: 2, name: "나연")
        ]
    }
    
    func getBlockedUserName(at index: Int) -> String? {
        guard index >= 0 && index < blockedUsers.count else {
            return nil
        }
        return blockedUsers[index].name
    }
}
