//
//  LoginTests.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 10/19/25.
//

import Testing
@testable import ByeBoo_iOS

struct AuthTests {
    
    @Test("🏁 isOnboardingCompleted가 true일 때 ✅ 자동로그인 success")
    func isOnboardingCompleted_true__autoLogin_success() async throws {
        // Given
        let authRepository = MockAuthRepository()
        let userDefaultsService: UserDefaultService = MockUserDefaultService()
        let _ = userDefaultsService.save(true, key: .isOnboardingCompleted)
        let autoLoginUseCase = DefaultAutoLoginUseCase(repository: authRepository)
        
        // When
        let result = try await autoLoginUseCase.execute()
        
        #expect(result == true)
        #expect(authRepository.isAutoLoginCalled == true)
    }
    
    @Test("🏁 로그아웃 호출 ✅ success")
    func logout__success() async throws {
        let authRepository = MockAuthRepository()
        let logoutUseCase = DefaultLogoutUseCase(repository: authRepository)
        let result = try await logoutUseCase.execute()
        
        #expect(result == true)
        #expect(authRepository.isLogoutCalled == true)
    }
    
    @Test("🏁 회원탈퇴 호출 ✅ success")
    func withdrawal__success() async throws {
        let authRepository = MockAuthRepository()
        let withdrawalUseCase = DefaultWithdrawUseCase(repository: authRepository)
        let result = try await withdrawalUseCase.execute()
        
        #expect(result == true)
        #expect(authRepository.isWithdrawCalled == true)
    }
}
