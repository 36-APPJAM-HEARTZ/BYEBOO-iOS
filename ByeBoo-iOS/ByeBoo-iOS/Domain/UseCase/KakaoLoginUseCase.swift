//
//  KakaoLoginUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/26/25.
//

import Foundation

protocol KakaoLoginUseCase {
    func execute(platform: LoginPlatform) async throws
}

struct DefaultKakaoLoginUseCase: KakaoLoginUseCase {
    private var repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute(platform: LoginPlatform) async throws {
        try await repository.kakaoLogin()
        return try await repository.postLogin(platform: platform)
    }
}
