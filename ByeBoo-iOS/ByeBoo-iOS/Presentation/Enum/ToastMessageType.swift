//
//  ToastMessageType.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/30/25.
//

import UIKit

enum ToastMessageType {
    
    case connectServerError
    case block
    case report
    case nicknameViolation
    case questViolation
    
    var image: UIImage {
        switch self {
        case .connectServerError, .nicknameViolation, .questViolation:
            return .errorToast
        case .block, .report:
            return .success
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .block, .report, .questViolation:
            return .black
        case .connectServerError, .nicknameViolation:
            return .black80
        }
    }
    
    var text: String {
        switch self {
        case .connectServerError:
            return "서버에 연결할 수 없습니다. 잠시 후 시도해 주세요."
        case .block:
            return "차단이 완료되었어요. 이에 해당 사용자의 글이 노출되지 않아요."
        case .report:
            return "신고가 접수되었어요. 처리 결과는 알림을 통해 알려드려요."
        case .nicknameViolation:
            return "비속어나 부적절한 단어가 포함된 닉네임은 등록할 수 없어요."
        case .questViolation:
            return "공통 퀘스트 답변은 모두에게 공개되기 때문에 부적절한 단어가 포함된 답변은 등록할 수 없어요."
        }
    }
}

