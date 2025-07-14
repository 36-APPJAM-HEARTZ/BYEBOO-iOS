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
        
        guard let getUserNameUseCase = DIContainer.shared.resolve(type: GetUserNameUseCase.self),
              let fetchUserJourneyUseCase = DIContainer.shared.resolve(type: FetchUserJourneyUseCase.self) else {
            ByeBooLogger.error(ByeBooError.DIFailedError)
            return
        }
        
        DIContainer.shared.register(type: JourneyResultViewModel.self) { _ in
            return JourneyResultViewModel(
                fetchUserJourneyUseCase: fetchUserJourneyUseCase,
                getUserNameUseCase: getUserNameUseCase
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
            guard let sendUserUseCase = container.resolve(type: SendUserUseCase.self) else {
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
                questAnswerCase: questAnswerUseCase
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
                fetchUserJourneyUseCase: fetchUserJourneyUseCase,
                getUserNameUseCase: getUserNameUseCase
            )
        }
        
        DIContainer.shared.register(type: QuestStartViewModel.self) { container in
            guard let startJourneyUseCase = container.resolve(type: StartJourneyUseCase.self)
            else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return QuestStartViewModel(
                startJourneyUseCase: startJourneyUseCase,
                getUserNameUseCase: getUserNameUseCase,
                fetchJourneyUseCase: fetchUserJourneyUseCase
            )
        }
    }
}
