//
//  QuestViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import Combine

final class QuestsViewModel: ViewModelType {
    
    private let cancellables = Set<AnyCancellable>()
    private let questsSubject = PassthroughSubject<Result<ProgressingQuestsEntity, ByeBooError>, Never>.init()
    private(set) var output: Output
    
    private let progressingQuestsUseCase: GetProgressingQuestsUseCase
    private let getUserIDUseCase: GetUserIDUseCase
    
    init(
        progressingQuestsUseCase: GetProgressingQuestsUseCase,
        getUserIDUseCase: GetUserIDUseCase
    ) {
        self.progressingQuestsUseCase = progressingQuestsUseCase
        self.getUserIDUseCase = getUserIDUseCase
        
        self.output = Output(questsPublisher: questsSubject.eraseToAnyPublisher())
    }
    
    private func fetchProgressingQuests() -> ProgressingQuestsEntity {
        guard let userID = getUserIDUseCase.execute() else {
            return .stub()
        }
        
        var quests: ProgressingQuestsEntity = .stub()
        
        Task {
            do {
                quests = try await progressingQuestsUseCase.execute(userID: userID)
            }
            catch {
                questsSubject.send(.failure(error as! ByeBooError))
            }
        }
        return quests
    }
}

extension QuestsViewModel {
    
    enum InputAction {
        case handleStartQuestButtonDidTap
    }
    
    struct Output {
        let questsPublisher: AnyPublisher<Result<ProgressingQuestsEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: InputAction) {
        switch trigger {
        case .handleStartQuestButtonDidTap:
            let questsEntity = fetchProgressingQuests()
            questsSubject.send(.success(questsEntity))
        }
    }
}
