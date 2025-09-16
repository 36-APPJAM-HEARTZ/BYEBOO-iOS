//
//  DataDependencyAssembler.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/30/25.
//

import Foundation

struct DataDependencyAssembler: DependencyAssembler {
    //    private let keychainService: KeychainService = DefaultKeychainService()
    //    private let userDefaultService: UserDefaultService = DefaultUserDefaultService()
    //    private lazy var tokenService: TokenService = DefaultTokenService(keychainService: keychainService)
    //    private lazy var interceptor = NetworkInterceptor(tokenService: tokenService)
    //    private lazy var networkService: NetworkService = DefaultNetworkService(interceptor: interceptor)
    
    func assemble() {
        let keychainService = DefaultKeychainService()
        let userDefaultService = DefaultUserDefaultService()
        let tokenService = DefaultTokenService(keychainService: keychainService)
        let interceptor = NetworkInterceptor(tokenService: tokenService)
        let networkService = DefaultNetworkService(interceptor: interceptor)
        
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
