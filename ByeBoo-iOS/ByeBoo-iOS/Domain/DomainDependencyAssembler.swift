//
//  DomainDependencyAssembler.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/30/25.
//

import Foundation

struct DomainDependencyAssembler: DependencyAssembler {
    private let preAssembler: DependencyAssembler
    
    init(preAssembler: DependencyAssembler) {
        self.preAssembler = preAssembler
    }
    
    func assemble() {
        preAssembler.assemble()
        
        guard let testRepository = DIContainer.shared.resolve(type: TestInterface.self) else { return }
        
        guard let userRepository = DIContainer.shared.resolve(type: UsersInterface.self) else {
            ByeBooLogger.error(ByeBooError.DIFailedError)
            return
        }
        
        guard let questInfoRepository = DIContainer.shared.resolve(type: GetQuestInfoInterface.self) else {
            ByeBooLogger.error(ByeBooError.DIFailedError)
            return
        }
        
        guard let saveQuestTypeRepository = DIContainer.shared.resolve(type: SaveQuestTypeInterface.self) else {
            ByeBooLogger.error(ByeBooError.DIFailedError)
            return
        }
        
        DIContainer.shared.register(type: TestUseCase.self) { container in
            return DefaultTestUseCase(testRepository: testRepository)
        }
        
        DIContainer.shared.register(type: FetchUserJourneyUseCase.self) { _ in
            return DefaultFetchUserJourneyUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: GetUserNameUseCase.self) { _ in
            return DefaultGetUserNameUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: GetQuestInfoUseCase.self) { _ in
            return DefaultGetQuestInfoUseCase(questInfoReposiroty: questInfoRepository)
        }
        
        DIContainer.shared.register(type: SaveQuestTypeUseCase.self) { _ in
            return DefaultSaveQuestTypeUseCase(repqository: saveQuestTypeRepository)
        }
    }
}
