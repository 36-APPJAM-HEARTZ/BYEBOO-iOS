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
        
        DIContainer.shared.register(type: TestUseCase.self) { container in
            return DefaultTestUseCase(testRepository: testRepository)
        }
        
        DIContainer.shared.register(type: FetchUserJourneyUseCase.self) { _ in
            return DefaultFetchUserJourneyUseCase(repository: userRepository)
        }
    }
}
