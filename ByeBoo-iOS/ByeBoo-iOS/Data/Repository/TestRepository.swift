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
    
    func fetchUserName() -> String {
        let result: UserResponseDTO = network.request()
        keychain.save()
        
        return result.name
    }
}

struct MockTestRepository: TestInterface {
    func fetchUserName() -> String {
        return "주리"
    }
}
