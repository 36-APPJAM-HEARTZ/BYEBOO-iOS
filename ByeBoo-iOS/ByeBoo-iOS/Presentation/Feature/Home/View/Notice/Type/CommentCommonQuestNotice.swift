//
//  CommentCommonQuestNotice.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 5/1/26.
//

import UIKit

struct CommentCommonQuestNotice: NoticeDisplayable {
    let nickname: String
    
    var isRead: Bool = false
    var iconImage: UIImage {
        .commonJourney
    }
    var title: String {
        "공통여정에 댓글이 달렸어요 💬"
    }
    var subtitle: String {
        "내가 작성한 글에 \(nickname)님이 댓글을 남겼어요"
    }
}
