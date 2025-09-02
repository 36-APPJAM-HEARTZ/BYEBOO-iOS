//
//  CompletedQuestsViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 9/1/25.
//

import Combine
import Foundation

final class CompletedQuestsViewModel {
    
    private let cancellables = Set<AnyCancellable>()
    private let nameSubject = PassthroughSubject<Result<String, ByeBooError>, Never>.init()
    private let questsSubject = PassthroughSubject<Result<CompletedQuestsEntity, ByeBooError>, Never>.init()
    
    private(set) var output: Output
    
    private let getUserNameUseCase: GetUserNameUseCase
    private let fetchCompletedQuestsUseCase: FetchCompletedQuestsUseCase
    
    private(set) var questsEntity: CompletedQuestsEntity?
    
    init(
        getUserNameUseCase: GetUserNameUseCase,
        fetchCompletedQuestsUseCase: FetchCompletedQuestsUseCase
    ) {
        self.getUserNameUseCase = getUserNameUseCase
        self.fetchCompletedQuestsUseCase = fetchCompletedQuestsUseCase
        
        self.output = Output(
            namePublisher: nameSubject.eraseToAnyPublisher(),
            questsPublisher: questsSubject.eraseToAnyPublisher()
        )
    }
    
    private func getUserName() {
        let name = getUserNameUseCase.execute()
        nameSubject.send(.success(name))
    }
    
    private func fetchCompletedQuests(journey: String) {
        Task {
            do {
                let completedQuestsEntity = try await fetchCompletedQuestsUseCase.execute(
                    journey: JourneyType.keyToEnum(journey) ?? .face
                )
                self.questsEntity = completedQuestsEntity
                questsSubject.send(.success(completedQuestsEntity))
            } catch {
                questsSubject.send(
                    .failure(
                        error as? ByeBooError ?? ByeBooError.unknownError
                    )
                )
            }
        }
    }
}

extension CompletedQuestsViewModel {
    
    var steps: [CompletedStepEntity] { questsEntity?.steps ?? [] }
    var currentStep: Int { questsEntity?.currentStep ?? 0 }
    
    func getStep(section: Int) -> CompletedStepEntity? {
        questsEntity?.steps[section]
    }
    
    func getQuestsCount(section: Int) -> Int {
        questsEntity?.steps[section].quests.count ?? 0
    }
    
    func getQuest(section: Int, item: Int) -> CompletedQuestEntity? {
        questsEntity?.steps[section].quests[item]
    }
}

extension CompletedQuestsViewModel: ViewModelType {
    
    enum Input {
        case viewWillAppear(journey: String)
    }
    
    struct Output {
        let namePublisher: AnyPublisher<Result<String, ByeBooError>, Never>
        let questsPublisher: AnyPublisher<Result<CompletedQuestsEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear(let journey):
            getUserName()
            fetchCompletedQuests(journey: journey)
        }
    }
}
