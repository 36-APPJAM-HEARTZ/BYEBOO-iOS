//
//  ToastMessageType.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/30/25.
//

import UIKit

enum ToastMessageType {
    
    case connectServerError
    
    var image: UIImage {
        switch self {
        case .connectServerError:
            return .errorToast
        }
    }
    
    var text: String {
        switch self {
        case .connectServerError:
            return "서버에 연결할 수 없습니다. 잠시 후 시도해 주세요."
        }
    }
}
