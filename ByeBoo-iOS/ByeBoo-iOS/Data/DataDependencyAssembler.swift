//
//  DataDependencyAssembler.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/30/25.
//

import Foundation

struct DataDependencyAssembler: DependencyAssembler {
    private let networkService: NetworkService = DefaultNetworkService()
    private let keychainService: KeychainService = DefaultKeychainService()
    private let userDefaultService: UserDefaultService = DefaultUserDefaultService()
    
    func assemble() {
        
        DIContainer.shared.register(type: UsersInterface.self) { _ in
            return DefaultUsersRepository(network: networkService, userDefatulsService: userDefaultService)
        }
        
        DIContainer.shared.register(type: GetQuestInfoInterface.self) { _ in
            return DefaultGetQuestInfoRepository(network: networkService, userDefaultService: userDefaultService)
        }
        
        DIContainer.shared.register(type: SaveQuestTypeInterface.self) { _ in
            return DefaultSaveQuestTypeRepository(network: networkService, userDefaultService: userDefaultService)
        }
        
        DIContainer.shared.register(type: QuestAnswerInterface.self) { _ in
            return DefaultQuestAnswerRepository(network: networkService, userDefaultService: userDefaultService)
        }
        
        DIContainer.shared.register(type: GetProgressingQuestsInterface.self) { _ in
            return DefaultGetProgressingQuestsRepository(
                network: networkService,
                userDefaultsService: userDefaultService
            )
                                                                               
        DIContainer.shared.register(type: QuestTipInterface.self) { _ in
            return DefaultQuestTipRepository(network: networkService, userDefaultService: userDefaultService)
        }
    }
}
