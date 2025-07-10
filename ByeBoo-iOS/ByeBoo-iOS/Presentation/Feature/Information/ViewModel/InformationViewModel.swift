//
//  InformationViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/9/25.
//

import Combine

final class InformationViewModel: ViewModelType {
    
    enum InputAction {
        case nicknameButtonDidTap(String)
        case emotionButtonDidTap(EmotionState)
        case questButtonDidTap(QuestStyle)
    }
    
    struct Output {
        let nicknamePublisher: AnyPublisher<Result<String, ByeBooError>, Never>
        let emotionPublisher: AnyPublisher<Result<EmotionState, ByeBooError>, Never>
        let questPublisher: AnyPublisher<Result<QuestStyle, ByeBooError>, Never>
        let userInformationPublisher: AnyPublisher<Result<UserEntity, ByeBooError>, Never>
    }
    
    private let nicknameSubject = PassthroughSubject<Result<String, ByeBooError>, Never>()
    private let emotionSubject = PassthroughSubject<Result<EmotionState, ByeBooError>, Never>()
    private let questSubject = PassthroughSubject<Result<QuestStyle, ByeBooError>, Never>()
    private let userInformationSubject = PassthroughSubject<Result<UserEntity, ByeBooError>, Never>()
    
    var currentNickname: String?
    private var currentEmotion: EmotionState?
    private var currentQuest: QuestStyle?
         
    var output: Output {
        Output(
            nicknamePublisher: nicknameSubject.eraseToAnyPublisher(),
            emotionPublisher: emotionSubject.eraseToAnyPublisher(),
            questPublisher: questSubject.eraseToAnyPublisher(),
            userInformationPublisher: userInformationSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: InputAction) {
        switch trigger {
        case .nicknameButtonDidTap(let nickname):
            currentNickname = nickname
            nicknameSubject.send(.success(nickname))
        case .emotionButtonDidTap(let emotionState):
            currentEmotion = emotionState
            emotionSubject.send(.success(emotionState))
        case .questButtonDidTap(let questStyle):
            currentQuest = questStyle
            questSubject.send(.success(questStyle))
            let user = createUserInformation(
                nickname: currentNickname,
                emotion: currentEmotion,
                quest: currentQuest
            )
            userInformationSubject.send(.success(user))
        }
    }
            
    func resetData() {
        currentEmotion = nil
        currentQuest = nil
    }
    
    // 실제로는 서버에 POST 요청을 통해 유저 정보 생성 예정
    private func createUserInformation(
        nickname: String?,
        emotion: EmotionState?,
        quest: QuestStyle?
    ) -> UserEntity {
        guard let nickname = nickname else {
            return UserEntity(userID: 1, name: "")
        }
        return UserEntity(userID: 1, name: nickname)
    }
}
