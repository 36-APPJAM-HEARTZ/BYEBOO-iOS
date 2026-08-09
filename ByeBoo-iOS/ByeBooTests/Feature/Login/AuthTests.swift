//
//  LoginTests.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 10/19/25.
//

import Testing
@testable import ByeBoo_iOS

struct AuthTests {
    
    private let userDefaultsService = MockUserDefaultService()
    private let keychainService = MockKeychainService()
    private let networkService = MockNetworkService(userAPI: MockUserAPI(isAvailable: true))
    
    @Test("🏁 isOnboardingCompleted가 true일 때 ✅ 자동로그인 success")
    func isRegistered_true__autoLogin_success() async throws {
        // Given
        let authRepository = MockAuthRepository(
            network: networkService,
            userDefaultsService: userDefaultsService,
            keychainService: keychainService
        )
        let _ = userDefaultsService.save(true, key: .isRegistered)
        let autoLoginUseCase = DefaultAutoLoginUseCase(repository: authRepository)
        
        // When
        let result = try await autoLoginUseCase.execute()
        
        // Then
        #expect(result == true)
        #expect(authRepository.isAutoLoginCalled == true)
    }
    
    @Test("🏁 로그아웃 호출 ✅ success")
    func logout__success() async throws {
        // Given
        let authRepository = MockAuthRepository(
            network: networkService,
            userDefaultsService: userDefaultsService,
            keychainService: keychainService
        )
        let logoutUseCase = DefaultLogoutUseCase(repository: authRepository)
        
        // When
        let result = try await logoutUseCase.execute()
        
        // Then
        #expect(result == true)
        #expect(authRepository.isLogoutCalled == true)
    }
    
    @Test("🏁 회원탈퇴 호출 ✅ success")
    func withdrawal__success() async throws {
        // Given
        let authRepository = MockAuthRepository(
            network: networkService,
            userDefaultsService: userDefaultsService,
            keychainService: keychainService
        )
        
        // When
        let withdrawalUseCase = DefaultWithdrawUseCase(repository: authRepository)
        let result = try await withdrawalUseCase.execute()
        
        // Then
        #expect(result == true)
        #expect(authRepository.isWithdrawCalled == true)
    }
}
