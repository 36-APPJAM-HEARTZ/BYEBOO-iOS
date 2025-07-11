//
//  CompleteQuestionTypeQuestViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import Combine
import Foundation

final class CompleteQuestViewModel: ViewModelType {
    
    enum InputAction {
        case questAnswerDidLoad
    }
    
    struct Output {
        let resultPublisher: AnyPublisher<Result<QuestAnswerEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: InputAction) {
        switch trigger {
        case .questAnswerDidLoad:
            let entity = fetchQuestAnswer()
            resultSubject.send(.success(entity))
        }
    }
    
    private var resultSubject: PassthroughSubject<Result<QuestAnswerEntity, ByeBooError>, Never> = .init()
    
    var output: Output {
        Output(
            resultPublisher: resultSubject.eraseToAnyPublisher()
        )
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
//    private let useCase: QuestAnswerUseCase
    
//    init(useCase: QuestAnswerUseCase) {
//        self.useCase = useCase
//    }
    
    init() { }
    
    private func fetchQuestAnswer() -> QuestAnswerEntity {
        let data = QuestAnswerEntity(
            stepNumber: 2,
            questNumber: 10,
            createdAt: "2025-07-10",
            question: "연애에서 반복됐던 문제 패턴 3가지를 생각해보아요.",
            answer: "내 X는 질투가 너무 많았슨... 그래서 동아리를 할 수가 없었슨.. 특히 솝트처럼 합숙하는 동아린 완전 금지였슨..ㅜㅜ",
            questEmotionState: "자기이해",
            imageUrl: "https://default.image/url.png",
            emotionDescription: "퀘스트를 통해 스스로에 대해 더 잘 알게 되셨네요! 아주 바람직하게 나아가고 있어요."
        )
        return data
    }
}
