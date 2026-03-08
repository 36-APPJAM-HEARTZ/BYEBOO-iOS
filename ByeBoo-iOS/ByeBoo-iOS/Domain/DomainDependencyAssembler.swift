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
        
        guard let userRepository = DIContainer.shared.resolve(type: UsersInterface.self),
              let questRepository = DIContainer.shared.resolve(type: QuestsInterface.self),
              let authRepository = DIContainer.shared.resolve(type: AuthInterface.self),
              let forbiddenWordRepository = DIContainer.shared.resolve(type: ForbiddenWordInterface.self),
              let commonQuestRepository = DIContainer.shared.resolve(type: CommonQuestInterface.self) else {
            ByeBooLogger.error(ByeBooError.DIFailedError)
            return
        }
        
        DIContainer.shared.register(type: FetchUserJourneyUseCase.self) { _ in
            return DefaultFetchUserJourneyUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: GetUserNameUseCase.self) { _ in
            return DefaultGetUserNameUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: GetQuestInfoUseCase.self) { _ in
            return DefaultGetQuestInfoUseCase(questInfoReposiroty: questRepository)
        }
        
        DIContainer.shared.register(type: GetUserIDUseCase.self) { _ in
            return DefaultGetUserIDUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: SaveQuestTypeUseCase.self) { _ in
            return DefaultSaveQuestTypeUseCase(repository: questRepository)
        }
        
        DIContainer.shared.register(type: CheckValidNicknameUseCase.self) { _ in
            return DefaultCheckValidNicknameUseCase()
        }
        
        DIContainer.shared.register(type: SendUserUseCase.self) { _ in
            return DefaultSenduserUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: QuestAnswerUseCase.self) { _ in
            return DefaultQuestAnswerUseCase(questAnswerRepository: questRepository)
        }
        
        DIContainer.shared.register(type: FetchCharacterDialogueUseCase.self) { _ in
            return DefaultFetchCharacterDialogueUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: FetchQuestStatusUseCase.self) { _ in
            return DefaultFetchQuestStatusUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: StartJourneyUseCase.self) { _ in
            return DefaultStartJourneyUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: GetIsRegisteredUseCase.self) { _ in
            return DefaultGetIsRegisteredUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: SaveQuestActiveUseCase.self) { _ in
            return DefaultSaveQuestActiveUseCase(questActiveRepository: questRepository)
        }
        
        DIContainer.shared.register(type: GetProgressingQuestsUseCase.self) { _ in
            return DefaultGetProgressingQuestsUseCase(repository: questRepository)
        }
        
        DIContainer.shared.register(type: QuestTipUseCase.self) { _ in
            return DefaultQuestTipUseCase(questTipRepository: questRepository)
        }
        
        DIContainer.shared.register(type: SetHelperUseCase.self) { _ in
            return DefaultSetHelperUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: GetHelperUseCase.self) { _ in
            return DefaultGetHelperUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: GetLookBackJourneyUseCase.self) { _ in
            return DefaultGetLookBackJourneyUseCase(lookBackJourneyRepository: questRepository)
        }
        
        DIContainer.shared.register(type: GetNewJourneyUseCase.self) { _ in
            return DefaultGetNewJourneyUseCase(lookBackJourneyRepository: questRepository)
        }
        
        DIContainer.shared.register(type: ModifyNicknameUseCase.self) { _ in
            return DefaultModifyNicknameUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: FetchNewJourneyUseCase.self) { _ in
            return DefaultFetchNewJourneyUseCase(fetchNewJourneyRepository: questRepository)
        }
        
        DIContainer.shared.register(type: EditQuestTypeUseCase.self) { _ in
            return DefaultEditQuestTypeUseCase(repository: questRepository)
        }
        
        DIContainer.shared.register(type: EditQuestActiveUseCase.self) { _ in
            return DefaultEditQuestActiveUseCase(repository: questRepository)
        }
        
        DIContainer.shared.register(type: SocialLoginUseCase.self) { _ in
            return DefaultSocialLoginUseCase(repository: authRepository)
        }
        
        DIContainer.shared.register(type: LogoutUseCase.self) { _ in
            return DefaultLogoutUseCase(repository: authRepository)
        }
        
        DIContainer.shared.register(type: WithdrawUseCase.self) { _ in
            return DefaultWithdrawUseCase(repository: authRepository)
        }
        
        DIContainer.shared.register(type: CalculateRemainingTimeUseCase.self) { _ in
            return DefaultCalculateRemainingTimeUseCase()
        }
        
        DIContainer.shared.register(type: FetchCompletedQuestsUseCase.self) { _ in
            return DefaultFetchCompletedQuestsUseCase(repository: questRepository)
        }
        
        DIContainer.shared.register(type: FetchCommonQuestByDateUseCase.self) { _ in
            return DefaultFetchCommonQuestByDateUseCase(repository: commonQuestRepository)
        }
        
        DIContainer.shared.register(type: AutoLoginUseCase.self) { _ in
            return DefaultAutoLoginUseCase(repository: authRepository)
        }
        
        DIContainer.shared.register(type: GetLastJourneyUseCase.self) { _ in
            return DefaultGetLastJourneyUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: ChangeNotificationPermissionUseCase.self) { _ in
            return DefaultChangeNotificationPermissionUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: CheckHasEnterMyPageUseCase.self) { _ in
            return DefaultCheckHasEnterMyPageUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: IsValidQuestAnswerUseCase.self) { _ in
            return DefaultIsValidQuestAnswerUseCase()
        }
        
        DIContainer.shared.register(type: CheckAlarmEnabledUseCase.self) { _ in
            return DefaultCheckAlarmEnabledUseCase(repository: userRepository)
        }
        
        DIContainer.shared.register(type: FetchCommonQuestMyAnswersUseCase.self) { _ in
            return DefaultFetchCommonQuestMyAnswersUseCase(repository: userRepository)
        }
      
        DIContainer.shared.register(type: FetchAIAnswerUseCase.self) { _ in
            return DefaultFetchAIAnswerUseCase(repository: questRepository)
        }
        
        DIContainer.shared.register(type: IsForbiddenWordUseCase.self) { _ in
            return DefaultIsForbiddenWordUseCase(repository: forbiddenWordRepository)
        }
        
        DIContainer.shared.register(type: SaveCommonQuestUseCase.self) { _ in
            return DefaultSaveCommonQuestUseCase(repository: commonQuestRepository)
        }
        
        DIContainer.shared.register(type: UpdateCommonQuestUseCase.self) { _ in
            return DefaultUpdateCommonQuestUseCase(repository: commonQuestRepository)
        }
    }
}
