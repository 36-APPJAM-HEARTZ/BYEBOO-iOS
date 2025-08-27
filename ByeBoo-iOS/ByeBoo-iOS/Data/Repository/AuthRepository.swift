//
//  AuthRepository.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/26/25.
//

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
    
    func kakaoLogin() async throws{
        let authorization = try await network.request()
        keychainService.save(key: .authorization, token: authorization)
    }
    
    func postLogin(platform: LoginPlatform) async throws {
        let loginRequestDTO = LoginRequestDTO(platform: platform.rawValue)
        let result = try await network.request(
            AuthAPI.login(requestDTO: loginRequestDTO),
            decodingType: PostLoginResponseDTO.self
        )
        _ = userDefaultsService.save(result.isRegistered, key: .isRegistered)
        keychainService.save(key: .accessToken, token: result.accessToken)
        keychainService.save(key: .refreshToken, token: result.refreshToken)
    }
    
}


struct MockAuthRepository: AuthInterface {
    func kakaoLogin() async throws  {
    }
    
    func postLogin(platform: LoginPlatform) async throws {
    }
}
