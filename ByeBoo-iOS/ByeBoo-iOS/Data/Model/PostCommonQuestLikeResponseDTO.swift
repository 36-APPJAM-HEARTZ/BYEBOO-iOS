//
//  postCommonQuestLikeResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 6/10/26.
//

import Foundation

struct PostCommonQuestLikeResponseDTO: Decodable {
    let likeCount: Int
    let isLiked: Bool
}

extension PostCommonQuestLikeResponseDTO {
    func toEntity() -> CommonQuestLikeEntity {
        .init(isLiked: isLiked, likeCount: likeCount)
    }
}
