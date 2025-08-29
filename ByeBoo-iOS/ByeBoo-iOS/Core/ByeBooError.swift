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
    case navigationControllerMissing
    case noData
    case unknownError
    case notFoundQuest
    case encodingError
    case beforeJourney
    case cannotOpenPage
    case kakaoOuathError
    case appleLoginError
    case endTimer
    
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
        case .navigationControllerMissing:
            return "네비게이션 컨트롤러 없음"
        case .noData:
            return "데이터 없음"
        case .encodingError:
            return "인코딩 실패"
        case .notFoundQuest:
            return "진행 중인 퀘스트가 없음"
        case .beforeJourney:
            return "여정 시작 전"
        case .cannotOpenPage:
            return "페이지를 열 수 없음"
        case .kakaoOuathError:
            return "카카오 액세스 토큰 받기 실패"
        case .appleLoginError:
            return "애플 로그인 실패"
        case .endTimer:
            return "타이머 종료"
        case .unknownError:
            return nil
        }
    }
}
