//
//  CommonQuestCommentRequestDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 6/14/26.
//

import Foundation

struct CommonQuestCommentRequestDTO: Encodable {
    let content: String
    let targetId: Int
}
