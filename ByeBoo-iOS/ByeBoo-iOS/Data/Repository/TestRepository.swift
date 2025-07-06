//
//  TestRepository.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import Foundation

struct DefaultTestRepository: TestInterface {
    private let network: NetworkService
    private let keychain: KeychainService
    
    init(network: NetworkService, keychain: KeychainService) {
        self.network = network
        self.keychain = keychain
    }
    
    func fetchUserName() async throws -> String {
        // TODO: UserDefaults에서 userID 꺼내는 로직 필요 지금은 임시값
        let result = try await network.request(HomeAPI.character(userID: 1), decodingType: UserResponseDTO.self)
        
        return result.name
    }
}

struct MockTestRepository: TestInterface {
    func fetchUserName() -> String {
        return "주리"
    }
}
