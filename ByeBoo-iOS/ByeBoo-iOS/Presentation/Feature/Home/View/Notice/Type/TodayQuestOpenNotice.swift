//
//  TodayQuestOpenNotice.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 5/1/26.
//

import UIKit

struct TodayQuestOpenNotice: NoticeDisplayable {
    let questNumber: Int
    
    var isRead: Bool = false
    var iconImage: UIImage {
        .myOn
    }
    var title: String {
        "오늘의 퀘스트 오픈 🌱"
    }
    var subtitle: String {
        "\(questNumber)번째 퀘스트가 오픈됐어요, 시작해볼까요?"
    }
}
