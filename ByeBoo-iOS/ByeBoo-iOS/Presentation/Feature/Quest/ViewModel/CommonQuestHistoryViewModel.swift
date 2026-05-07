//
//  CommonQuestHistoryViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/5/26.
//

import Combine
import Foundation

final class CommonQuestHistoryViewModel {
    private(set) var commentLists: [CommonQuestCommentEntity] = CommonQuestCommentEntity.toCommentListStub()
    
    func getCommentsCount() -> Int {
        return commentLists.count
    }
}
