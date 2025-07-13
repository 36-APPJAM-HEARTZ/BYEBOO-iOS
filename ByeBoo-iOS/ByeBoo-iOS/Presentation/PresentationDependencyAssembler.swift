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
        
        DIContainer.shared.register(type: JourneyResultViewModel.self) { container in
            guard let fetchUserUseCase = container.resolve(type: FetchUserJourneyUseCase.self),
                  let getNameUseCase = container.resolve(type: GetUserNameUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return JourneyResultViewModel(
                fetchUserJourneyUseCase: fetchUserUseCase,
                getUserNameUseCase: getNameUseCase
            )
        }
        
        DIContainer.shared.register(type: WriteQuestionTypeViewModel.self) { container in
            guard let getQuestInfoUseCase = container.resolve(type: GetQuestInfoUseCase.self),
                let saveQuestTypeUseCase = container.resolve(type: SaveQuestTypeUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            return WriteQuestionTypeViewModel(
                saveQuestTypeUseCase: saveQuestTypeUseCase,
                getQuestInfoUseCase: getQuestInfoUseCase
            )
        }
        
        DIContainer.shared.register(type: WriteActiveTypeViewModel.self) { container in
            guard let getQuestInfoUseCase = container.resolve(type: GetQuestInfoUseCase.self),
                let saveQuestTypeUseCase = container.resolve(type: SaveQuestTypeUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            return WriteActiveTypeViewModel(
                saveQuestTypeUseCase: saveQuestTypeUseCase,
                getQuestInfoUseCase: getQuestInfoUseCase
            )
        }

        DIContainer.shared.register(type: InformationViewModel.self) { container in
            guard let sendUserUseCase = container.resolve(type: SendUserUseCase.self),
                  let getUserNameUseCase = container.resolve(type: GetUserNameUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return InformationViewModel(
                sendUserUseCase: sendUserUseCase,
                getUserNameUseCase: getUserNameUseCase
            )
        }
        
        DIContainer.shared.register(type: CompleteQuestViewModel.self) { container in
            guard let questAnswerUseCase = container.resolve(type: QuestAnswerUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return CompleteQuestViewModel(
                useCase: questAnswerUseCase
            )
        }
    }
}
