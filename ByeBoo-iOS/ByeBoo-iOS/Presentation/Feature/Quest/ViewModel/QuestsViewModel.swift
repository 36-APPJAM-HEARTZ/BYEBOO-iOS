//
//  QuestViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import Combine

final class QuestsViewModel: ViewModelType {
    
    enum InputAction {
        case handleStartQuestButtonDidTap
    }
    
    struct Output {
        let questsPublisher: AnyPublisher<Result<QuestsEntity, ByeBooError>, Never>
    }
    
    private let questSubject = PassthroughSubject<Result<QuestsEntity, ByeBooError>, Never>.init()
    lazy var output = Output(questsPublisher: questSubject.eraseToAnyPublisher())
    
    func action(_ trigger: InputAction) {
        switch trigger {
        case .handleStartQuestButtonDidTap:
            let questsEntity = fetchQuests()
            questSubject.send(.success(questsEntity))
        }
    }
    
    private func fetchQuests() -> QuestsEntity {
        return QuestsEntity(
            progressPeriod: "8",
            currentStep: 9,
            isCompleted: false,
            steps: [
                StepEntity(
                    stepNumber: 1,
                    step: "감정 쏟아내기",
                    quests: [
                        QuestEntity(
                            questId: 31,
                            questNumber: 1
                        ),
                        QuestEntity(
                            questId: 32,
                            questNumber: 2
                        ),
                        QuestEntity(
                            questId: 33,
                            questNumber: 3
                        ),
                        QuestEntity(
                            questId: 34,
                            questNumber: 4
                        ),
                        QuestEntity(
                            questId: 35,
                            questNumber: 5
                        )
                    ]
                ),
                StepEntity(
                    stepNumber: 2,
                    step: "상황 정리하기",
                    quests: [
                        QuestEntity(
                            questId: 36,
                            questNumber: 6
                        ),
                        QuestEntity(
                            questId: 37,
                            questNumber: 7
                        ),
                        QuestEntity(
                            questId: 38,
                            questNumber: 8
                        ),
                        QuestEntity(
                            questId: 39,
                            questNumber: 9
                        ),
                        QuestEntity(
                            questId: 40,
                            questNumber: 10
                        )
                    ]
                ),
                StepEntity(
                    stepNumber: 3,
                    step: "내 역할 돌아보기",
                    quests: [
                        QuestEntity(
                            questId: 41,
                            questNumber: 11
                        ),
                        QuestEntity(
                            questId: 42,
                            questNumber: 12
                        ),
                        QuestEntity(
                            questId: 43,
                            questNumber: 13
                        ),
                        QuestEntity(
                            questId: 44,
                            questNumber: 14
                        ),
                        QuestEntity(
                            questId: 45,
                            questNumber: 15
                        )
                    ]
                )
            ]
        )
    }
}

