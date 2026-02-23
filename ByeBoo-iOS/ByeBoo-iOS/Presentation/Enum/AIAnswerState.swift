//
//  AIAnswerState.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 2/18/26.
//

import UIKit

enum AIAnswerState {
    case loading
    case fail
    case success
}

extension AIAnswerState {
    var text: String {
        switch self {
        case .loading:
            "보리가 열심히 답변을 작성하고 있어요!"
        case .fail:
            "답변 생성을 실패했어요.\n잠시 뒤에 다시 시도해 주세요."
        case .success:
            ""
        }
    }
    
    var image: UIImage {
        switch self {
        case .loading:
                .boriWriting
        case .fail:
                .boriRetry
        case .success:
                .boriLetter
        }
    }
}
