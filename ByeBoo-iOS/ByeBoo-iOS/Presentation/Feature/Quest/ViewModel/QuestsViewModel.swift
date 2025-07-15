//
//  QuestViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import Combine

final class QuestsViewModel: ViewModelType {
    
    private let cancellables = Set<AnyCancellable>()
    private let nameSubject = PassthroughSubject<Result<String, ByeBooError>, Never>.init()
    private let journeySubject = PassthroughSubject<Result<JourneyEntity, ByeBooError>, Never>.init()
    private let questsSubject = PassthroughSubject<Result<ProgressingQuestsEntity, ByeBooError>, Never>.init()
    private(set) var output: Output
    
    private let progressingQuestsUseCase: GetProgressingQuestsUseCase
    private let getUserIDUseCase: GetUserIDUseCase
    private let getUserNameUseCase: GetUserNameUseCase
    private let fetchUserJourneyUseCase: FetchUserJourneyUseCase
    
    init(
        progressingQuestsUseCase: GetProgressingQuestsUseCase,
        getUserIDUseCase: GetUserIDUseCase,
        getUserNameUseCase: GetUserNameUseCase,
        fetchUserJourneyUseCase: FetchUserJourneyUseCase
    ) {
        self.progressingQuestsUseCase = progressingQuestsUseCase
        self.getUserIDUseCase = getUserIDUseCase
        self.getUserNameUseCase = getUserNameUseCase
        self.fetchUserJourneyUseCase = fetchUserJourneyUseCase
        
        self.output = Output(
            namePublisher: nameSubject.eraseToAnyPublisher(),
            journeyPublisher: journeySubject.eraseToAnyPublisher(),
            questsPublisher: questsSubject.eraseToAnyPublisher()
        )
    }
    
    private func getUseName() {
        let name = getUserNameUseCase.execute()
        nameSubject.send(.success(name))
    }
    
    private func fetchUserJourney() {
        Task {
            do {
                let journeyEntity = try await fetchUserJourneyUseCase.execute()
                journeySubject.send(.success(journeyEntity))
            } catch {
                journeySubject.send(
                    .failure(
                        error as? ByeBooError ?? ByeBooError.unknownError
                    )
                )
            }
        }
    }
    
    private func fetchProgressingQuests() {
        guard let userID = getUserIDUseCase.execute() else {
            questsSubject.send(.success(.stub()))
            return
        }
        
        Task {
            do {
                let quests = try await progressingQuestsUseCase.execute(userID: userID)
                questsSubject.send(.success(quests))
            } catch {
                questsSubject.send(.failure(error as! ByeBooError))
            }
        }
    }
}

extension QuestsViewModel {
    
    enum InputAction {
        case questViewWillAppear
    }
    
    struct Output {
        let namePublisher: AnyPublisher<Result<String, ByeBooError>, Never>
        let journeyPublisher: AnyPublisher<Result<JourneyEntity, ByeBooError>, Never>
        let questsPublisher: AnyPublisher<Result<ProgressingQuestsEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: InputAction) {
        switch trigger {
        case .questViewWillAppear:
            getUseName()
            fetchUserJourney()
            fetchProgressingQuests()
        }
    }
}
