//
//  PresentationDependencyAssembler.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/30/25.
//

import Foundation

struct PresentationDependencyAssembler: DependencyAssembler {
    private let preAssembler: DependencyAssembler
    
    init(preAssembler: DependencyAssembler) {
        self.preAssembler = preAssembler
    }
    
    func assemble() {
        preAssembler.assemble()
        
        guard let getUserNameUseCase = DIContainer.shared.resolve(type: GetUserNameUseCase.self) else {
            ByeBooLogger.error(ByeBooError.DIFailedError)
            return
        }
        
        DIContainer.shared.register(type: JourneyResultViewModel.self) { container in
            guard let fetchUserUseCase = container.resolve(type: FetchUserJourneyUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return JourneyResultViewModel(
                fetchUserJourneyUseCase: fetchUserUseCase,
                getUserNameUseCase: getUserNameUseCase
            )
        }
        
        DIContainer.shared.register(type: InformationViewModel.self) { container in
            guard let sendUserUseCase = container.resolve(type: SendUserUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return InformationViewModel(
                sendUserUseCase: sendUserUseCase,
                getUserNameUseCase: getUserNameUseCase
            )
        }
        
        DIContainer.shared.register(type: HomeViewModel.self) { container in
            guard let characterUseCase = container.resolve(type: FetchCharacterDialogueUseCase.self),
            let countUseCase = container.resolve(type: FetchCompleteQuestCountUseCase.self)
            else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return HomeViewModel(
                fetchCharacterDialogueUseCase: characterUseCase,
                fetchCompleteQuestCountUseCase: countUseCase,
                getUserNameUseCase: getUserNameUseCase
            )
        }
    }
}
