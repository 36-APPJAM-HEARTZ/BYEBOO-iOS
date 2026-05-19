//
//  CommonQuestReplyViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/8/26.
//

import Foundation

final class CommonQuestReplyViewModel {
    func getCommentContent() -> CommonQuestCommentEntity {
        return CommonQuestCommentEntity.toCommentStub()
    }
    
    func getReplyList() -> [CommonQuestCommentEntity] {
        return CommonQuestCommentEntity.toReplyListStub()
    }
}
