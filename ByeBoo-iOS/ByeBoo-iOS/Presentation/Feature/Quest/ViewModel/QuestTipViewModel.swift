//
//  QuestTipViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import Combine
import Foundation

final class QuestTipViewModel: ViewModelType {
    
    private var questTipSubject: PassthroughSubject<Result<QuestTipDataEntity, ByeBooError>, Never> = .init()
     
    var output: Output {
        Output(
            questTipPublisher: questTipSubject.eraseToAnyPublisher()
        )
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let useCase: QuestTipUseCase
    
    init(useCase: QuestTipUseCase) {
        self.useCase = useCase
    }
}

extension QuestTipViewModel {
    enum Input {
        case questTipDidLoad(questID: Int)
    }
    
    struct Output {
        let questTipPublisher: AnyPublisher<Result<QuestTipDataEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .questTipDidLoad(let questID):
            fetchQuestTips(questID: questID)
        }
    }
    
}

extension QuestTipViewModel {
    private func fetchQuestTips(questID: Int)  {
        Task {
            do {
                let tips = try await useCase.fetchQuestTips(questID: questID)
                questTipSubject.send((.success(tips)))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                ByeBooLogger.error(error as ByeBooError)
                questTipSubject.send(.failure(error))
            }
        }
    }
}
