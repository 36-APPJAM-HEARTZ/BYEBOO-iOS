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
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .DIFailedError:
            return "의존성 주입 실패"
        case .decodingError:
            return "디코딩 실패"
        case .unknownError:
            return nil
        }
    }
}
