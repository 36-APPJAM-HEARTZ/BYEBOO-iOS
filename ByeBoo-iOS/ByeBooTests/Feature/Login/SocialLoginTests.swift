//
//  SocialLoginTests.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 10/29/25.
//

import Testing
@testable import ByeBoo_iOS

struct SocialLoginTests {
    
    private let accessToken = OAuthTokenFactory.makeOAuthToken().accessToken
    private let userDefaultsService = MockUserDefaultService()
    private let keychainService = MockKeychainService()
    
    @Test(
        "🏁 카카오 인증 서버로부터 isKakaoTalkLoginAvailable와 관계없이 ✅ acessToken 받아오기 성공",
        arguments: [true, false]
    )
    func postIDTokenFromKakaoServer__success(isKakaoAvailable: Bool) throws {
        let networkService = MockNetworkService(userAPI: MockUserAPI(isAvailable: isKakaoAvailable))
        
        let idToken = try networkService.kakaoRequest()
        
        #expect(idToken == accessToken)
    }
    
    @Test("🏁 카카오 인증 서버로부터 isKakaoTalkLoginAvailable와 관계없이 ✅ acessToken 받아오기 성공")
    func kakaoLogin__success() async throws {
        // Given
        let dto = PostLoginResponseDTO.stub()
        let networkService = MockNetworkService(userAPI: MockUserAPI(isAvailable: true))
        let authRepository = MockAuthRepository(
            network: networkService,
            userDefaultsService: userDefaultsService,
            keychainService: keychainService
        )
        userDefaultsService.deleteAll()
        keychainService.deleteAll()
        
        // When
        try await authRepository.kakaoLogin(platform: .KAKAO)
        
        // Then
        let platform: String? = userDefaultsService.load(key: .loginPlatform)
        let isRegistered: Bool? = userDefaultsService.load(key: .isRegistered)
        let userName: String? = userDefaultsService.load(key: .userName)
        let journey: String? = userDefaultsService.load(key: .journey)
        let journeyStatus: String? = userDefaultsService.load(key: .journeyStatus)
        let userID: Int? = userDefaultsService.load(key: .userID)
        let accessToken: String? = keychainService.load(key: .accessToken)
        let refreshToken: String? = keychainService.load(key: .refreshToken)
        
        #expect(authRepository.kakaoLoginCalled)
        #expect(networkService.kakaoRequestCalled)
        #expect(platform == LoginPlatform.KAKAO.rawValue)
        #expect(isRegistered == true)
        #expect(userName == dto.name)
        #expect(journey == dto.journey)
        #expect(journeyStatus == dto.journeyStatus)
        #expect(userID == 0)
        #expect(accessToken == dto.accessToken)
        #expect(refreshToken == dto.refreshToken)
    }
}
