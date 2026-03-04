//
//  ByeBooError.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/1/25.
//

import Foundation

enum ByeBooError: Error, LocalizedError, Equatable {
    case DIFailedError
    case decodingError
    case URLError
    case networkRequestFailed
    case networkConnect
    case networkError(code: Int, message: String)
    case navigationControllerMissing
    case noData
    case unknownError
    case notFound
    case encodingError
    case beforeJourney
    case cannotOpenPage
    case kakaoOuathError
    case appleLoginError
    case endTimer
    case configError
    case fileNotFound
    case nicknameViolation
    case questViolation
    
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
        case .networkConnect:
            return "네트워크 연결 에러"
        case .networkError(let code, let message):
            return "\(code): \(message)"
        case .navigationControllerMissing:
            return "네비게이션 컨트롤러 없음"
        case .noData:
            return "데이터 없음"
        case .encodingError:
            return "인코딩 실패"
        case .notFound:
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
        case .configError:
            return "info에서 값을 찾을 수 없음"
        case .fileNotFound:
            return "파일을 찾을 수 없음"
        case .nicknameViolation:
            return "비속어나 부적절한 단어가 포함된 닉네임"
        case .questViolation:
            return "비속어나 부적절한 단어가 포함된 답변"
        }
    }
}
