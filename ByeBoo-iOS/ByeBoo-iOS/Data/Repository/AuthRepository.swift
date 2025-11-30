//
//  AuthRepository.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/26/25.
//

import AuthenticationServices
import Foundation

import Firebase
import FirebaseMessaging

struct DefaultAuthRepository: AuthInterface {
    private let network: NetworkService
    private let keychainService: KeychainService
    private let userDefaultsService: UserDefaultService
    private let tokenService: TokenService
    
    init(
        network: NetworkService,
        keychainService: KeychainService,
        userDefaultsService: UserDefaultService,
        tokenService: TokenService
    ) {
        self.network = network
        self.keychainService = keychainService
        self.userDefaultsService = userDefaultsService
        self.tokenService = tokenService
    }
    
    // MARK: Network
    
    func kakaoLogin(platform: LoginPlatform) async throws {
        let authorization = try await network.kakaoRequest()
        let _ = userDefaultsService.save("KAKAO", key: .loginPlatform)
        keychainService.save(key: .authorization, token: authorization)
        try await postLogin(platform: platform)
    }
    
    func appleLogin(platform: LoginPlatform) async throws {
        let (identityToken, authorizationCode) = try await network.appleRequest()
        let _ = userDefaultsService.save("APPLE", key: .loginPlatform)
        keychainService.save(key: .authorization, token: identityToken)
        keychainService.save(key: .authorizationCode, token: authorizationCode)
        try await postLogin(platform: platform)
    }
    
    
    private func postLogin(platform: LoginPlatform) async throws {
        let loginRequestDTO = LoginRequestDTO(platform: platform.rawValue)
        let header: HeaderType
        
        let loginPlatform: String? = userDefaultsService.load(key: .loginPlatform)
        guard let loginPlatform = loginPlatform else { return }
        
        switch loginPlatform {
        case "KAKAO":
            ByeBooLogger.debug("카카오 post login")
            header = .withAuth(acessToken: keychainService.load(key: .authorization))
        case "APPLE":
            ByeBooLogger.debug("apple post login")
            header = .withAuthCode(
                acessToken: keychainService.load(key: .authorization),
                authorizationCode: keychainService.load(key: .authorizationCode)
            )
        default:
            return
        }
       
        let result = try await network.request(
            AuthAPI.login(header: header, requestDTO: loginRequestDTO),
            decodingType: PostLoginResponseDTO.self
        )
        
        _ = userDefaultsService.save(result.isRegistered, key: .isRegistered)
        _ = userDefaultsService.save(result.name ?? "" , key: .userName)
        _ = userDefaultsService.save(result.journey ?? "", key: .journey)
        _ = userDefaultsService.save(result.journeyStatus ?? "", key: .journeyStatus)
        _ = userDefaultsService.save(result.userId, key: .userID)
        
        keychainService.save(key: .accessToken, token: result.accessToken)
        keychainService.save(key: .refreshToken, token: result.refreshToken)
        
        keychainService.delete(key: .authorization)
        keychainService.delete(key: .authorizationCode)
        
        do {
            let fcmToken = try await Messaging.messaging().token()
            let fcmTokenDTO = FCMTokenDTO(token: fcmToken)
            try await network.request(
                NotificationAPI.saveToken(accessToken: result.accessToken, dto: fcmTokenDTO)
            )
        } catch (let error) {
            ByeBooLogger.error(error)
        }
    }
    
    func autoLogin() async throws -> Bool {
        let isOnboardingCompleted: Bool = userDefaultsService.load(key: .isOnboardingCompleted) ?? false
        ByeBooLogger.debug(isOnboardingCompleted)
        
        if !keychainService.load(key: .accessToken).isEmpty
            && !keychainService.load(key: .refreshToken).isEmpty
            && isOnboardingCompleted
        {
            ByeBooLogger.debug("정보 있음")
            try await tokenService.reissue()
            return true
        } else {
            ByeBooLogger.debug("정보 없음")
            clearKeychain()
            return false
        }
    }
    
    func logout() async throws -> Bool {
        let accessToken = keychainService.load(key: .accessToken)
        let header: HeaderType = .withAuth(acessToken: accessToken)
        
        do {
            try await network.request(
                AuthAPI.logout(header: header)
            )
            
            guard let fcmToken: String = userDefaultsService.load(key: .fcmToken) else {
                return false
            }
            try await network.request(
                NotificationAPI.deleteToken(accessToken: accessToken, dto: .init(token: fcmToken))
            )
        }
        catch (let error) {
            ByeBooLogger.debug("Logout failed: \(error)")
            return false
        }
        
        clearKeychain()
        removeUserInfo(excludedKeys: [.isOnboardingCompleted, .isHelperShown, .hasEnterMyPage])
        
        return true
    }
    
    func withdraw() async throws -> Bool {
        let header: HeaderType = .withAuth(acessToken: keychainService.load(key: .accessToken))
        
        do {
            try await network.request(
                AuthAPI.withdraw(header: header)
            )
        }
        catch (let error) {
            ByeBooLogger.debug("Logout failed: \(error)")
            return false
        }
        
        clearKeychain()
        removeUserInfo()
        return true
    }
}

extension DefaultAuthRepository {
    private func clearKeychain() {
        for key in KeyType.allCases {
            let token = keychainService.load(key: key)
                if !token.isEmpty {
                    keychainService.delete(key: key)
                    ByeBooLogger.debug("\(key) 삭제")
            }
        }
    }
    
    private func removeUserInfo(excludedKeys: [UserDefaultsKey] = []) {
        for key in UserDefaultsKey.allCases {
            guard !excludedKeys.contains(key) else { continue }
            let _ = userDefaultsService.delete(key: key)
            ByeBooLogger.debug("\(key) 삭제")
        }
    }
}

final class MockAuthRepository: AuthInterface {
    
    private(set) var kakaoLoginCalled = false
    private(set) var appleLoginCalled = false
    private(set) var isAutoLoginCalled = false
    private(set) var isLogoutCalled = false
    private(set) var isWithdrawCalled = false
    
    private let network: NetworkService
    private let userDefaultsService: UserDefaultService
    private let keychainService: KeychainService
    
    init(
        network: NetworkService,
        userDefaultsService: UserDefaultService,
        keychainService: KeychainService
    ) {
        self.network = network
        self.userDefaultsService = userDefaultsService
        self.keychainService = keychainService
    }
    
    func kakaoLogin(platform: LoginPlatform) async throws  {
        kakaoLoginCalled = true
        
        let authorization = try await network.kakaoRequest()
        let _ = userDefaultsService.save("KAKAO", key: .loginPlatform)
        keychainService.save(key: .authorization, token: authorization)
        try await postLogin(platform: platform)
    }
    
    func appleLogin(platform: LoginPlatform) async throws {
        appleLoginCalled = true
        
        var (identityToken, authorizationCode) = try await network.appleRequest()
        let _ = userDefaultsService.save("APPLE", key: .loginPlatform)
        keychainService.save(key: .authorization, token: identityToken)
        keychainService.save(key: .authorizationCode, token: authorizationCode)
        try await postLogin(platform: platform)
    }
    
    func autoLogin() async throws -> Bool {
        isAutoLoginCalled = true
        return true
    }
    
    func logout() async throws -> Bool {
        isLogoutCalled = true
        return true
    }
    
    func withdraw() async throws -> Bool {
        isWithdrawCalled = true
        return true
    }
    
    func clearKeychain() {}
    
    private func postLogin(platform: LoginPlatform) async throws {
        let postLoginResult = PostLoginResponseDTO.stub()
        
        _ = userDefaultsService.save(postLoginResult.isRegistered, key: .isRegistered)
        _ = userDefaultsService.save(postLoginResult.name ?? "" , key: .userName)
        _ = userDefaultsService.save(postLoginResult.journey ?? "", key: .journey)
        _ = userDefaultsService.save(postLoginResult.journeyStatus ?? "", key: .journeyStatus)
        _ = userDefaultsService.save(postLoginResult.userId, key: .userID)
        
        keychainService.save(key: .accessToken, token: postLoginResult.accessToken)
        keychainService.save(key: .refreshToken, token: postLoginResult.refreshToken)
        
        keychainService.delete(key: .authorization)
        keychainService.delete(key: .authorizationCode)
    }
}
