//
//  InformationViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/9/25.
//

import Combine

final class InformationViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private let userInformationSubject = PassthroughSubject<Result<UserEntity, ByeBooError>, Never>()
    private let userNameSubject = PassthroughSubject<Result<String, ByeBooError>, Never>()
    private(set) var output: Output
    
    private var currentNickname: String?
    private var currentFeeling: Feeling?
    private var currentQuestStyle: QuestStyle?
    private var user: UserEntity = UserEntity(id: 1, name: "")
    
    private let sendUserUseCase: SendUserUseCase
    private let getUserNameUseCase: GetUserNameUseCase
    
    init(
        sendUserUseCase: SendUserUseCase,
        getUserNameUseCase: GetUserNameUseCase
    ) {
        self.sendUserUseCase = sendUserUseCase
        self.getUserNameUseCase = getUserNameUseCase
        
        self.output = Output(
            userInformationPublisher: userInformationSubject.eraseToAnyPublisher(),
            userNamePublisher: userNameSubject.eraseToAnyPublisher()
        )
    }
    
    private func createUserInformation(
        nickname: String?,
        feeling: Feeling?,
        questStyle: QuestStyle?
    ) -> UserEntity {
        guard let name = currentNickname,
              let feeling = currentFeeling,
              let questStyle = currentQuestStyle else {
            return user
        }
        
        Task {
            do {
                user = try await sendUserUseCase.execute(
                    name: name,
                    feeling: feeling.key,
                    questStyle: questStyle.key
                )
                getUserName()
            } catch {
                userInformationSubject.send(.failure(error as! ByeBooError))
            }
        }
        return user
    }
    
    private func getUserName() {
        let name = getUserNameUseCase.execute()
        userNameSubject.send(.success(name))
    }
}

extension InformationViewModel: ViewModelType {
    
    enum InputAction {
        case nicknameButtonDidTap(String)
        case feelingButtonDidTap(Feeling)
        case questButtonDidTap(QuestStyle)
    }
    
    struct Output {
        let userInformationPublisher: AnyPublisher<Result<UserEntity, ByeBooError>, Never>
        let userNamePublisher: AnyPublisher<Result<String, ByeBooError>, Never>
    }
    
    func action(_ trigger: InputAction) {
        switch trigger {
        case .nicknameButtonDidTap(let nickname):
            currentNickname = nickname
        case .feelingButtonDidTap(let feeling):
            currentFeeling = feeling
        case .questButtonDidTap(let questStyle):
            currentQuestStyle = questStyle
            let user = createUserInformation(
                nickname: currentNickname,
                feeling: currentFeeling,
                questStyle: currentQuestStyle
            )
            userInformationSubject.send(.success(user))
        }
    }
}

extension InformationViewModel {
    
    func resetData() {
        currentFeeling = nil
        currentQuestStyle = nil
    }
}
