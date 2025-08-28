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
        let _ = userDefaultsService.save("KAKAO", key: .loginPlatcform)
        keychainService.save(key: .authorization, token: authorization)
        try await postLogin(platform: platform)
    }
    
    func appleLogin(platform: LoginPlatform) async throws {
        let (identityToken, _) = try await network.appleRequest()
        let _ = userDefaultsService.save("APPLE", key: .loginPlatcform)
        keychainService.save(key: .authorization, token: identityToken)
        try await postLogin(platform: platform)
    }
    
    
    private func postLogin(platform: LoginPlatform) async throws {
        let loginRequestDTO = LoginRequestDTO(platform: platform.rawValue)
        let result = try await network.request(
            AuthAPI.login(requestDTO: loginRequestDTO),
            decodingType: PostLoginResponseDTO.self
        )
        _ = userDefaultsService.save(result.isRegistered, key: .isRegistered)
        keychainService.save(key: .accessToken, token: result.accessToken)
        keychainService.save(key: .refreshToken, token: result.refreshToken)
    }
    
    func logout() async throws {
        try await network.request(AuthAPI.logout)
    }
    
    func withdraw() async throws {
        let loginPlatform: String? = userDefaultsService.load(key: .loginPlatcform)
        guard let loginPlatform = loginPlatform else { return }
        
        switch loginPlatform {
        case "KAKAO":
            return try await network.request(AuthAPI.withdraw)
        case "APPLE":
            let (_, authorizationCode) = try await network.appleRequest()
            keychainService.save(key: .authorizationCode, token: authorizationCode)
            return try await network.request(AuthAPI.withdraw)
        default :
            return
        }
    }
}


struct MockAuthRepository: AuthInterface {
    func kakaoLogin(platform: LoginPlatform) async throws  {
    }
    
    func appleLogin(platform: LoginPlatform) async throws {
    }
    
    func logout() async throws {
    }
    
    func withdraw() async throws {
    }
}
