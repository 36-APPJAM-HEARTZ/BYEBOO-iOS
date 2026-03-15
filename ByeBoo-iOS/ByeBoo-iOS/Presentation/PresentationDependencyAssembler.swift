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
              let fetchUserJourneyUseCase = DIContainer.shared.resolve(type: FetchUserJourneyUseCase.self),
              let isForbiddenWordUseCase = DIContainer.shared.resolve(type: IsForbiddenWordUseCase.self)
        else {
            ByeBooLogger.error(ByeBooError.DIFailedError)
            return
        }
        
        DIContainer.shared.register(type: CardJourneyViewModel.self) { _ in
            return CardJourneyViewModel(
                fetchUserJourneyUseCase: fetchUserJourneyUseCase,
                getUserNameUseCase: getUserNameUseCase
            )
        }
        
        DIContainer.shared.register(type: WriteQuestionTypeViewModel.self) { container in
            guard let getQuestInfoUseCase = container.resolve(type: GetQuestInfoUseCase.self),
                  let saveQuestTypeUseCase = container.resolve(type: SaveQuestTypeUseCase.self),
                  let editQuestTypeUseCase = container.resolve(type: EditQuestTypeUseCase.self),
                  let isValidQuestAnswerUseCase = container.resolve(type: IsValidQuestAnswerUseCase.self),
                  let saveCommonQuestUseCase = container.resolve(type: SaveCommonQuestUseCase.self),
                  let isForbiddenWordUseCase = container.resolve(type: IsForbiddenWordUseCase.self),
                  let updateCommonQuestUseCase = container.resolve(type: UpdateCommonQuestUseCase.self)
            else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            return WriteQuestionTypeViewModel(
                saveQuestTypeUseCase: saveQuestTypeUseCase,
                getQuestInfoUseCase: getQuestInfoUseCase,
                editQuestTypeUseCase: editQuestTypeUseCase,
                isValidQuestAnswerUseCase: isValidQuestAnswerUseCase,
                saveCommonQuestUseCase: saveCommonQuestUseCase,
                isForbiddenWordUseCase: isForbiddenWordUseCase,
                updateCommonQuestUseCase: updateCommonQuestUseCase
            )
        }
        
        DIContainer.shared.register(type: WriteActiveTypeViewModel.self) { container in
            guard let getQuestInfoUseCase = container.resolve(type: GetQuestInfoUseCase.self),
                  let saveActiveTypeUseCase = container.resolve(type: SaveQuestActiveUseCase.self),
                  let saveQuestTypeUseCase = container.resolve(type: SaveQuestTypeUseCase.self),
                  let editActiveQuestType = container.resolve(type: EditQuestActiveUseCase.self),
                  let isValidTextUseCase = container.resolve(type: IsValidQuestAnswerUseCase.self) else  {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            return WriteActiveTypeViewModel(
                saveQuestTypeUseCase: saveQuestTypeUseCase,
                saveActiveTypeUseCase: saveActiveTypeUseCase,
                getQuestInfoUseCase: getQuestInfoUseCase,
                editActiveQuestUseCase: editActiveQuestType,
                isValidQuestAnswerUseCase: isValidTextUseCase
            )
        }
        
        DIContainer.shared.register(type: InformationViewModel.self) { container in
            guard let checkValidNickNameUseCase = container.resolve(type: CheckValidNicknameUseCase.self),
                  let isForbiddenWordUseCase = container.resolve(type: IsForbiddenWordUseCase.self),
                  let sendUserUseCase = container.resolve(type: SendUserUseCase.self),
                  let getUserNameUseCase = container.resolve(type: GetUserNameUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return InformationViewModel(
                checkValidNicknameUseCase: checkValidNickNameUseCase,
                isForbiddenWordUseCase: isForbiddenWordUseCase,
                sendUserUseCase: sendUserUseCase,
                getUserNameUseCase: getUserNameUseCase
            )
        }
        
        DIContainer.shared.register(type: ArchiveQuestViewModel.self) { container in
            guard let questAnswerUseCase = container.resolve(type: QuestAnswerUseCase.self),
                  let fetchAIAnswerUseCase = container.resolve(type: FetchAIAnswerUseCase.self)
            else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return ArchiveQuestViewModel(
                questAnswerUseCase: questAnswerUseCase
            )
        }
        
        
        DIContainer.shared.register(type: HomeViewModel.self) { container in
            guard let characterUseCase = container.resolve(type: FetchCharacterDialogueUseCase.self),
                  let questStatusUseCase = container.resolve(type: FetchQuestStatusUseCase.self),
                  let setHelperUseCase = container.resolve(type: SetHelperUseCase.self),
                  let fetchUserJourneyUseCase = container.resolve(type: FetchUserJourneyUseCase.self),
                  let getUserNameUseCase = container.resolve(type: GetUserNameUseCase.self),
                  let getHelperUseCase = container.resolve(type: GetHelperUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return HomeViewModel(
                fetchCharacterDialogueUseCase: characterUseCase,
                fetchQuestStatusUseCase: questStatusUseCase,
                fetchUserJourneyUseCase: fetchUserJourneyUseCase,
                getUserNameUseCase: getUserNameUseCase,
                setHelperUseCase: setHelperUseCase,
                getHelperUseCase: getHelperUseCase
            )
        }
        
        DIContainer.shared
            .register(type: QuestStartViewModel.self) { container in
                guard let startJourneyUseCase = container.resolve(type: StartJourneyUseCase.self),
                      let fetchUserJourneyUseCase = container.resolve(type: FetchUserJourneyUseCase.self),
                      let getUserNameUseCase = container.resolve(type: GetUserNameUseCase.self),
                      let postNewJourneyUseCase = container.resolve(type: FetchNewJourneyUseCase.self) else {
                    ByeBooLogger.error(ByeBooError.DIFailedError)
                    return
                }
                
                return QuestStartViewModel(
                    startJourneyUseCase: startJourneyUseCase,
                    getUserNameUseCase: getUserNameUseCase,
                    fetchJourneyUseCase: fetchUserJourneyUseCase,
                    postJourneyUseCase: postNewJourneyUseCase
                )
            }
        
        DIContainer.shared
            .register(type: ProgressingQuestsViewModel.self) { container in
                guard let progressingQuestsUseCase = container.resolve(type: GetProgressingQuestsUseCase.self),
                      let fetchUserJourneyUseCase = container.resolve(type: FetchUserJourneyUseCase.self),
                      let getUserNameUseCase = container.resolve(type: GetUserNameUseCase.self),
                      let calculateRemainingTimeUseCase = container.resolve(type: CalculateRemainingTimeUseCase.self) else {
                    ByeBooLogger.error(ByeBooError.DIFailedError)
                    return
                }
                
                return ProgressingQuestsViewModel(
                    progressingQuestsUseCase: progressingQuestsUseCase,
                    getUserNameUseCase: getUserNameUseCase,
                    fetchUserJourneyUseCase: fetchUserJourneyUseCase,
                    calculateRemainingTimeUseCase: calculateRemainingTimeUseCase
                )
            }
        
        DIContainer.shared.register(type: QuestTipViewModel.self) { container in
            guard let questTipUseCase = container.resolve(
                type: QuestTipUseCase.self
            )
            else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return QuestTipViewModel(
                useCase: questTipUseCase
            )
        }
        
        DIContainer.shared.register(type: MyPageViewModel.self) { container in
            guard let getUserNameUseCase = container.resolve(type: GetUserNameUseCase.self),
                  let logoutUseCase = container.resolve(type: LogoutUseCase.self),
                  let withdrawUseCase = container.resolve(type: WithdrawUseCase.self),
                  let changeNotificationPermissionUseCase = container.resolve(type: ChangeNotificationPermissionUseCase.self),
                  let checkHasEnterMyPageUseCase = container.resolve(type: CheckHasEnterMyPageUseCase.self),
                  let checkAlarmEnabledUseCase = container.resolve(type: CheckAlarmEnabledUseCase.self)
            else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return MyPageViewModel(
                getUserNameUseCase: getUserNameUseCase,
                logoutUseCase: logoutUseCase,
                withdrawUseCase: withdrawUseCase,
                changeNotificationPermissionUseCase: changeNotificationPermissionUseCase,
                checkHasEnterMyPageUseCase: checkHasEnterMyPageUseCase,
                checkAlarmEnabledUseCase: checkAlarmEnabledUseCase
            )
        }
        
        DIContainer.shared.register(type: LookBackJourneyViewModel.self) { container in
            guard let getLookBackJourneyUseCase = container.resolve(
                type: GetLookBackJourneyUseCase.self
            )
            else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return LookBackJourneyViewModel(
                useCase: getLookBackJourneyUseCase
            )
        }
        
        DIContainer.shared.register(type: NewJourneyViewModel.self) { container in
            guard let getNewJourneyUseCase = container.resolve(type: GetNewJourneyUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return NewJourneyViewModel(
                getNewJourneyUseCase: getNewJourneyUseCase
            )
        }
        
        DIContainer.shared.register(type: ModifyNicknameViewModel.self) { container in
            guard let checkValidNicknameUseCase = container.resolve(type: CheckValidNicknameUseCase.self),
                  let isForbiddenWordUseCase =  container.resolve(type: IsForbiddenWordUseCase.self),
                  let modifyNicknameUseCase = container.resolve(type: ModifyNicknameUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return ModifyNicknameViewModel(
                checkValidNicknameUseCase: checkValidNicknameUseCase,
                isForbiddenWordUseCase: isForbiddenWordUseCase,
                modifyNicknameUseCase: modifyNicknameUseCase
            )
        }
        
        DIContainer.shared.register(type: LoginViewModel.self) { container in
            guard let socialLoginUseCase = container.resolve(type: SocialLoginUseCase.self),
                  let getIsRegisteredUseCase = container.resolve(type: GetIsRegisteredUseCase.self),
                  let getUserIDUseCase = container.resolve(type: GetUserIDUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return LoginViewModel(
                socialLoginUseCase: socialLoginUseCase,
                getIsRegisteredUseCase: getIsRegisteredUseCase,
                getUserIDUseCase: getUserIDUseCase
            )
        }
        
        DIContainer.shared.register(type: CompletedQuestsViewModel.self) { container in
            guard let getUserNameUseCase = container.resolve(type: GetUserNameUseCase.self),
                  let fetchCompletedQuestsUseCase = container.resolve(type: FetchCompletedQuestsUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            return CompletedQuestsViewModel(
                getUserNameUseCase: getUserNameUseCase,
                fetchCompletedQuestsUseCase: fetchCompletedQuestsUseCase
            )
        }
        
        DIContainer.shared.register(type: SplashViewModel.self) { container in
            guard let autoLoginUseCase = container.resolve(
                type: AutoLoginUseCase.self
            )
            else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            return SplashViewModel(autoLoginUseCase: autoLoginUseCase)
        }
        
        DIContainer.shared.register(type: FinishJourneyViewModel.self) { container in
            guard let getUserNameUseCase = container.resolve(type: GetUserNameUseCase.self),
                  let getLastJourneyUseCase = container.resolve(type: GetLastJourneyUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return FinishJourneyViewModel(
                getUserNameUseCase: getUserNameUseCase,
                getLastJourneyUseCase: getLastJourneyUseCase
            )
        }
        
        DIContainer.shared.register(type: CommonQuestViewModel.self) { container in
            guard let fetchCommonQuestByDateUseCase = container.resolve(type: FetchCommonQuestByDateUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return CommonQuestViewModel(
                fetchCommonQuestByDateUseCase: fetchCommonQuestByDateUseCase
            )
        }
        
        DIContainer.shared.register(type: CommonQuestMyAnswerViewModel.self) { container in
            guard let getUserNameUseCase = container.resolve(type: GetUserNameUseCase.self),
                  let fetchCommonQuestMyAnswersUseCase = container.resolve(type: FetchCommonQuestMyAnswersUseCase.self) else  {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return CommonQuestMyAnswerViewModel(
                getUserNameUseCase: getUserNameUseCase,
                fetchCommonQuestMyAnswersUseCase: fetchCommonQuestMyAnswersUseCase
            )
        }
        
        DIContainer.shared.register(type: CommonQuestBottomSheetViewModel.self) { container in
            guard let blockUserUseCase = container.resolve(
                type: BlockUserUseCase.self
            ),
                  let reportQuestAnswerUseCase = container.resolve(type: ReportsCommonQuestAnswerUseCase.self),
                  let deleteCommonQuestUseCase = container.resolve(type: DeleteCommonQuestUseCase.self)
            else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return CommonQuestBottomSheetViewModel(
                blockUserUseCase: blockUserUseCase,
                reportCommonQuestUseCase: reportQuestAnswerUseCase,
                deleteCommonQuestUseCase: deleteCommonQuestUseCase
            )
        }
        
        
        DIContainer.shared.register(type: AIAnswerViewModel.self) { container in
            guard let fetchAIAnswerUseCase = container.resolve(type: FetchAIAnswerUseCase.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return AIAnswerViewModel(fetchAIAnswerUseCase: fetchAIAnswerUseCase)
        }
        
        DIContainer.shared.register(type: BlockedUserListViewModel.self) { container in
            guard let getBlockedUsersListUseCase = container.resolve(type: GetBlockedUsersListUseCase.self),
                  let deleteBlockedUserUseCase = container.resolve(type: DeleteBlockedUserUseCase.self) else  {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                return
            }
            
            return BlockedUserListViewModel(
                getBlockedUsersListUseCase: getBlockedUsersListUseCase,
                deleteBlockedUserUseCase: deleteBlockedUserUseCase
            )
        }
    }
}
