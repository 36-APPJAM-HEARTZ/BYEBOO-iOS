//
//  DataDependencyAssembler.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/30/25.
//

import Foundation

struct DataDependencyAssembler: DependencyAssembler {
    private let keychainService: KeychainService = DefaultKeychainService()
    private let userDefaultService: UserDefaultService = DefaultUserDefaultService()
    private let tokenService: TokenService
    private let interceptor: NetworkInterceptor
    private let networkService: NetworkService
    
    init() {
        self.tokenService = DefaultTokenService(keychainService: keychainService)
        self.interceptor = NetworkInterceptor(tokenService: tokenService)
        self.networkService = DefaultNetworkService(interceptor: interceptor)
    }
    
    func assemble() {        
        DIContainer.shared.register(type: UsersInterface.self) { _ in
            return DefaultUsersRepository(network: networkService, userDefaultsService: userDefaultService)
        }
        
        DIContainer.shared.register(type: QuestsInterface.self) { _ in
            return DefaultQuestRepository(network: networkService, userDefaultsService: userDefaultService)
        }
        
        DIContainer.shared.register(type: AuthInterface.self) { _ in
            return DefaultAuthRepository(network: networkService, keychainService: keychainService, userDefaultsService: userDefaultService, tokenService: tokenService)
        }
    }
}

struct MockDataDependencyAssembler: DependencyAssembler {
    func assemble() {
        DIContainer.shared.register(type: UsersInterface.self) { _ in
            return MockUserRepository()
        }
        
        DIContainer.shared.register(type: QuestsInterface.self) { _ in
            return MockQuestsRepository()
        }
        
        DIContainer.shared.register(type: AuthInterface.self) { _ in
            return MockAuthRepository()
        }
    }
}
