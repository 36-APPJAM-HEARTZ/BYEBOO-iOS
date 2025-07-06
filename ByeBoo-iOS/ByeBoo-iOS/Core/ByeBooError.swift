//
//  ByeBooError.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/1/25.
//

import Foundation

enum ByeBooError: Error, LocalizedError {
    case DIFailedError
    case decodingError
    case URLError
    case networkRequestFailed
    case networkError(code: Int, message: String)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .DIFailedError:
            return "의존성 주입 실패"
        case .decodingError:
            return "디코딩 실패"
        case .URLError:
            return "URL 변환 실패"
        case .networkRequestFailed:
            return "네트워크 요청 실패"
        case .networkError(let code, let message):
            return "\(code): \(message)"
        case .unknownError:
            return nil
        }
    }
}
