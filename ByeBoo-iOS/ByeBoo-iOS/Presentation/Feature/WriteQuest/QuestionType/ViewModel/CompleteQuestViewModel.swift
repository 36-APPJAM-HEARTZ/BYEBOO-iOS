//
//  CompleteQuestionTypeQuestViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import Combine
import Foundation

final class CompleteQuestViewModel: ViewModelType {
    
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var output: Output
    
    private let questAnswerUseCase: QuestAnswerUseCase
    
    private var resultSubject: PassthroughSubject<Result<QuestAnswerEntity, ByeBooError>, Never> = .init()
    
    init(
        questAnswerCase: QuestAnswerUseCase
    ) {
        self.questAnswerUseCase = questAnswerCase
        
        output = Output(
            resultPublisher: resultSubject.eraseToAnyPublisher()
        )
    }
}

extension CompleteQuestViewModel {
    enum Input {
        case questAnswerDidLoad(questID: Int)
    }
    
    struct Output {
        let resultPublisher: AnyPublisher<Result<QuestAnswerEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .questAnswerDidLoad(let questID):
            fetchQuestAnswer(questID: questID)
        }
    }
}

extension CompleteQuestViewModel {
    private func fetchQuestAnswer(questID: Int) {
        Task {
            do {
                let entity = try await questAnswerUseCase.execute(questID: questID)
                resultSubject.send(.success(entity))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                resultSubject.send(.failure(error))
            }
        }
    }
}
