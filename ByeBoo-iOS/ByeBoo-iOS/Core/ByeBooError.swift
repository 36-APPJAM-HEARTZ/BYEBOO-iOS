//
//  ByeBooError.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/1/25.
//

import Foundation

enum ByeBooError: Error, LocalizedError {
    case decodingError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "디코딩 실패"
        case .unknownError:
            return nil
        }
    }
}
