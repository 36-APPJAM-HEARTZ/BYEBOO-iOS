//
//  KakaoLoginUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/26/25.
//

import Foundation

protocol SocialLoginUseCase {
    func execute(platform: LoginPlatform) async throws
}

struct DefaultKakaoLoginUseCase: SocialLoginUseCase {
    private var repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute(platform: LoginPlatform) async throws {
        switch platform {
        case .KAKAO:
            return try await repository.kakaoLogin(platform: platform)
        case .APPLE:
            return try await repository.appleLogin(platform: platform)
        }
        
    }
}
