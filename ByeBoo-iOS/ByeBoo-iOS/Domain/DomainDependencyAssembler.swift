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
        
        guard let userRepository = DIContainer.shared.resolve(type: UsersInterface.self) else {
            ByeBooLogger.error(ByeBooError.DIFailedError)
            return
        }
        
        DIContainer.shared.register(type: FetchUserJourneyUseCase.self) { _ in
            return DefaultFetchUserJourneyUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: GetUserNameUseCase.self) { _ in
            return DefaultGetUserNameUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: SendUserUseCase.self) { _ in
            return DefaultSenduserUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: FetchCharacterDialogueUseCase.self) { _ in
            return DefaultFetchCharacterDialogueUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: FetchCompleteQuestCountUseCase.self) { _ in
            return DefaultFetchCompleteQuestCountUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: StartJourneyUseCase.self) { _ in
            return DefaultStartJourneyUseCase(repository: userRepository)
        }
    }
}
