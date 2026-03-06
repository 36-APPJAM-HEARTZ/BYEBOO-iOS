//
//  CompleteQuestionTypeQuestViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import Combine
import Foundation

final class ArchiveQuestViewModel: ViewModelType {
    
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var output: Output
    
    private let questAnswerUseCase: QuestAnswerUseCase
    
    private var resultSubject = PassthroughSubject<Result<QuestAnswerEntity, ByeBooError>, Never>()
    private var loadingSubject = PassthroughSubject<
        Bool, Never>()
    
    private(set) var entity: QuestAnswerEntity?
    private(set) var questID: Int = 1
    
    init(
        questAnswerUseCase: QuestAnswerUseCase
    ) {
        self.questAnswerUseCase = questAnswerUseCase
        
        output = Output(
            resultPublisher: resultSubject.eraseToAnyPublisher(),
            loadingPublisher: loadingSubject.eraseToAnyPublisher()
        )
    }
}

extension ArchiveQuestViewModel {
    enum Input {
        case questAnswerDidLoad(questID: Int)
    }
    
    struct Output {
        let resultPublisher: AnyPublisher<Result<QuestAnswerEntity, ByeBooError>, Never>
        let loadingPublisher: AnyPublisher<Bool, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .questAnswerDidLoad(let questID):
            self.questID = questID
            fetchQuestAnswer(questID: questID)
        }
    }
}

extension ArchiveQuestViewModel {
    func isAIAnswerExists() -> Bool {
        return entity?.AIAnswerExists ?? false
    }
}

extension ArchiveQuestViewModel {
    private func fetchQuestAnswer(questID: Int) {
        Task {
            do {
                loadingSubject.send(true)
                entity = try await questAnswerUseCase.execute(questID: questID)
                guard let entity = self.entity else { return }
                resultSubject.send(.success(entity))
                loadingSubject.send(false)
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                resultSubject.send(.failure(error))
                loadingSubject.send(false)
            }
        }
    }
}
