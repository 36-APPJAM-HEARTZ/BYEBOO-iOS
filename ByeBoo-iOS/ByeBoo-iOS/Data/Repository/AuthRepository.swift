//
//  AuthRepository.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/26/25.
//

import AuthenticationServices
import Foundation

struct DefaultAuthRepository: AuthInterface {
    private let network: NetworkService
    private let keychainService: KeychainService
    private let userDefaultsService: UserDefaultService
    
    init(
        network: NetworkService,
        keychainService: KeychainService,
        userDefaultsService: UserDefaultService
    ) {
        self.network = network
        self.keychainService = keychainService
        self.userDefaultsService = userDefaultsService
    }
    
    // MARK: Network
    
    func kakaoLogin(platform: LoginPlatform) async throws {
        let authorization = try await network.kakaoRequest()
        let _ = userDefaultsService.save("KAKAO", key: .loginPlatform)
        keychainService.save(key: .authorization, token: authorization)
        try await postLogin(platform: platform)
    }
    
    func appleLogin(platform: LoginPlatform) async throws {
        let (identityToken, _) = try await network.appleRequest()
        let _ = userDefaultsService.save("APPLE", key: .loginPlatform)
        keychainService.save(key: .authorization, token: identityToken)
        try await postLogin(platform: platform)
    }
    
    
    private func postLogin(platform: LoginPlatform) async throws {
        let loginRequestDTO = LoginRequestDTO(platform: platform.rawValue)
        let header: HeaderType = .withAuth(acessToken: keychainService.load(key: .authorization))
        let result = try await network.request(
            AuthAPI.login(header: header, requestDTO: loginRequestDTO),
            decodingType: PostLoginResponseDTO.self
        )
        _ = userDefaultsService.save(result.isRegistered, key: .isRegistered)
        _ = userDefaultsService.save(result.name ?? "" , key: .userName)
        _ = userDefaultsService.save(result.journey ?? "", key: .journey)
        _ = userDefaultsService.save(result.journeyStatus ?? "", key: .journeyStatus)
        keychainService.save(key: .accessToken, token: result.accessToken)
        keychainService.save(key: .refreshToken, token: result.refreshToken)
    }
    
    func reissue() async throws {
        try await network.tokenReissue()
    }
    
    func hasTokens() -> Bool {
        if !keychainService.load(key: .accessToken).isEmpty && !keychainService.load(key: .refreshToken).isEmpty {
            ByeBooLogger.debug("정보 있음")
            return true
        } else {
            ByeBooLogger.debug("정보 없음")
            return false
        }
    }
    
    func logout() async throws {
        let header: HeaderType = .withAuth(acessToken: keychainService.load(key: .accessToken))
        try await network.request(
            AuthAPI.logout(header: header)
        )
        
        removeTokenInfo()
    }
    
    func withdraw() async throws {
        let loginPlatform: String? = userDefaultsService.load(key: .loginPlatform)
        guard let loginPlatform = loginPlatform else { return }
        
        switch loginPlatform {
        case "KAKAO":
            let header: HeaderType = .withAuth(acessToken: keychainService.load(key: .accessToken))
            try await network.request(
                AuthAPI.withdraw(header: header)
            )
            removeTokenInfo()
        case "APPLE":
            // TODO: - authroization code 서버에서 처리하기 
            let (_, authorizationCode) = try await network.appleRequest()
            keychainService.save(key: .authorizationCode, token: authorizationCode)
            
            let header: HeaderType = .withAuthCode(
                acessToken: keychainService.load(key: .accessToken),
                authorizationCode: keychainService.load(key: .authorizationCode)
            )
            
            try await network.request(
                AuthAPI.withdraw(header: header)
            )
            removeTokenInfo()
            removeUserInfo()
        default :
            return
        }
    }
}

extension DefaultAuthRepository {
    private func removeTokenInfo() {
        for key in KeyType.allCases {
            let token = keychainService.load(key: key)
                if !token.isEmpty {
                    ByeBooLogger.debug("remove 실행: \(key.rawValue)")
                    keychainService.delete(key: key)
            }
        }
    }
    
    private func removeUserInfo() {
        for key in UserDefaultsKey.allCases {
            let _ = userDefaultsService.delete(key: key)
        }
    }
}

struct MockAuthRepository: AuthInterface {
    func kakaoLogin(platform: LoginPlatform) async throws  {
    }
    
    func appleLogin(platform: LoginPlatform) async throws {
    }
    
    func reissue() async throws {
    }
    
    func hasTokens() -> Bool {
        return false
    }
    
    func logout() async throws {
    }
    
    func withdraw() async throws {
    }
}
