//
//  InformationViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/9/25.
//

import Combine

final class InformationViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private let nicknameValidationSubject = CurrentValueSubject<Bool, Never>(false)
    private let isForbiddenWordSubject = PassthroughSubject<Result<Void, ByeBooError>, Never>()
    private let userInformationSubject = PassthroughSubject<Result<Void, ByeBooError>, Never>()
    private let userNameSubject = PassthroughSubject<Result<String, ByeBooError>, Never>()
    private(set) var output: Output
    
    private var currentNickname: String?
    private var currentQuestStyle: SelectQuestType?
    private var user: UserEntity = UserEntity(id: 1, name: "")
    
    private let checkValidNicknameUseCase: CheckValidNicknameUseCase
    private let isForbiddenWordUseCase: IsForbiddenWordUseCase
    private let sendUserUseCase: SendUserUseCase
    private let getUserNameUseCase: GetUserNameUseCase
    
    init(
        checkValidNicknameUseCase: CheckValidNicknameUseCase,
        isForbiddenWordUseCase: IsForbiddenWordUseCase,
        sendUserUseCase: SendUserUseCase,
        getUserNameUseCase: GetUserNameUseCase
    ) {
        self.checkValidNicknameUseCase = checkValidNicknameUseCase
        self.isForbiddenWordUseCase = isForbiddenWordUseCase
        self.sendUserUseCase = sendUserUseCase
        self.getUserNameUseCase = getUserNameUseCase
        
        self.output = Output(
            nicknameValidationPublisher: nicknameValidationSubject.eraseToAnyPublisher(),
            isForbiddenWordPublisher: isForbiddenWordSubject.eraseToAnyPublisher(),
            userInformationPublisher: userInformationSubject.eraseToAnyPublisher(),
            userNamePublisher: userNameSubject.eraseToAnyPublisher()
        )
    }
    
    private func createUserInformation(
        nickname: String?,
        questStyle: SelectQuestType?
    ) {
        guard let name = currentNickname,
              let questStyle = currentQuestStyle else { return }
        
        Task {
            do {
                let _ = try await sendUserUseCase.execute(
                    name: name,
                    questStyle: questStyle.key
                )
                getUserName()
            } catch {
                userInformationSubject.send(.failure(error as! ByeBooError))
            }
        }
    }
    
    private func getUserName() {
        let name = getUserNameUseCase.execute()
        userNameSubject.send(.success(name))
    }
}

extension InformationViewModel: ViewModelType {
    
    enum Input {
        case editingNickname(String)
        case nicknameButtonDidTap(String)
        case questButtonDidTap(SelectQuestType)
    }
    
    struct Output {
        let nicknameValidationPublisher: AnyPublisher<Bool, Never>
        let isForbiddenWordPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
        let userInformationPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
        let userNamePublisher: AnyPublisher<Result<String, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .editingNickname(let nickname):
            let isValidNickname = checkValidNicknameUseCase.isValidRegulation(nickname: nickname)
            nicknameValidationSubject.send(isValidNickname)
            
        case .nicknameButtonDidTap(let nickname):
            guard checkValidNicknameUseCase.isPermitteed(nickname: nickname),
                  !isForbiddenWordUseCase.execute(word: nickname)
            else {
                isForbiddenWordSubject.send(.failure(.nicknameViolation))
                return
            }
            currentNickname = nickname
            isForbiddenWordSubject.send(.success(()))
            
        case .questButtonDidTap(let questStyle):
            currentQuestStyle = questStyle
            createUserInformation(
                nickname: currentNickname,
                questStyle: currentQuestStyle
            )
            userInformationSubject.send(.success(()))
        }
    }
}

extension InformationViewModel {
    
    func resetData() {
        currentQuestStyle = nil
    }
}
