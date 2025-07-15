//
//  QuestViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import Combine

final class QuestsViewModel: ViewModelType {
    
    private let cancellables = Set<AnyCancellable>()
    private let nameSubject = CurrentValueSubject<Result<String, ByeBooError>?, Never>(nil)
    private let journeySubject = CurrentValueSubject<Result<JourneyEntity, ByeBooError>?, Never>(nil)
    private let questsSubject = CurrentValueSubject<Result<ProgressingQuestsEntity, ByeBooError>?, Never>(nil)
    
    private(set) var output: Output
    
    var isReadyToPresentPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(
            nameSubject,
            journeySubject,
            questsSubject
        )
        .map { nameResult, journeyResult, questsResult in
            if case .success = nameResult,
               case .success = journeyResult,
               case .success = questsResult {
                return true
            } else {
                return false
            }
        }
        .removeDuplicates()
        .eraseToAnyPublisher()
    }
    
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
            namePublisher: nameSubject.compactMap { $0 }.eraseToAnyPublisher(),
            journeyPublisher: journeySubject.compactMap { $0 }.eraseToAnyPublisher(),
            questsPublisher: questsSubject.compactMap { $0 }.eraseToAnyPublisher()
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
    
    func reset() {
        nameSubject.send(nil)
        journeySubject.send(nil)
        questsSubject.send(nil)
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
