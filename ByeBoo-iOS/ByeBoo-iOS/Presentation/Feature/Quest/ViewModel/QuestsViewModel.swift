//
//  QuestViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import Combine
import Foundation

final class QuestsViewModel {
    
    private let cancellables = Set<AnyCancellable>()
    private let nameSubject = PassthroughSubject<Result<String, ByeBooError>, Never>.init()
    private let journeySubject = PassthroughSubject<Result<JourneyEntity, ByeBooError>, Never>.init()
    private let questsSubject = PassthroughSubject<Result<ProgressingQuestsEntity, ByeBooError>, Never>.init()
    private let loadingSubject = PassthroughSubject<Bool, Never>.init()
    private let timeSubject = PassthroughSubject<Result<String, ByeBooError>, Never>.init()
    
    private(set) var output: Output
    
    private let progressingQuestsUseCase: GetProgressingQuestsUseCase
    private let getUserIDUseCase: GetUserIDUseCase
    private let getUserNameUseCase: GetUserNameUseCase
    private let fetchUserJourneyUseCase: FetchUserJourneyUseCase
    private let calculateRemainingTimeUseCase: CalculateRemainingTimeUseCase
    
    private var questsEntity: ProgressingQuestsEntity?
    private var timeCancellabels: AnyCancellable?
    
    init(
        progressingQuestsUseCase: GetProgressingQuestsUseCase,
        getUserIDUseCase: GetUserIDUseCase,
        getUserNameUseCase: GetUserNameUseCase,
        fetchUserJourneyUseCase: FetchUserJourneyUseCase,
        calculateRemainingTimeUseCase: CalculateRemainingTimeUseCase
    ) {
        self.progressingQuestsUseCase = progressingQuestsUseCase
        self.getUserIDUseCase = getUserIDUseCase
        self.getUserNameUseCase = getUserNameUseCase
        self.fetchUserJourneyUseCase = fetchUserJourneyUseCase
        self.calculateRemainingTimeUseCase = calculateRemainingTimeUseCase
        
        self.output = Output(
            namePublisher: nameSubject.eraseToAnyPublisher(),
            journeyPublisher: journeySubject.eraseToAnyPublisher(),
            questsPublisher: questsSubject.eraseToAnyPublisher(),
            loadingPublisher: loadingSubject.eraseToAnyPublisher(),
            timePublisher: timeSubject.eraseToAnyPublisher()
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
                loadingSubject.send(false)
            } catch {
                journeySubject.send(
                    .failure(
                        error as? ByeBooError ?? ByeBooError.unknownError
                    )
                )
                loadingSubject.send(false)
            }
        }
    }
    
    private func fetchProgressingQuests() {
        Task {
            do {
                let questsEntity = try await progressingQuestsUseCase.execute()
                self.questsEntity = questsEntity
                self.setQuestTimer()
                questsSubject.send(.success(questsEntity))
                loadingSubject.send(false)
            } catch {
                questsSubject.send(.failure(error as! ByeBooError))
                loadingSubject.send(false)
            }
        }
    }
    
    private func setQuestTimer() {
        var remainingSeconds = calculateRemainingTimeUseCase.calculateRemainingTime(
            questOpenTime: questsEntity?.questOpenTime,
            currentTime: questsEntity?.currentTime
        )

        timeCancellabels?.cancel()
        timeCancellabels = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                if remainingSeconds > 0 {
                    remainingSeconds -= 1
                    let time = self.calculateRemainingTimeUseCase.formatRemainingTime(seconds: remainingSeconds)
                    self.timeSubject.send(.success(time))
                    return
                }
                self.timeCancellabels?.cancel()
                self.timeSubject.send(.failure(.endTimer))
            }
    }
}

extension QuestsViewModel {
    
    var steps: [StepEntity] { questsEntity?.steps ?? [] }
    var currentStep: Int { questsEntity?.currentStep ?? 0 }
    var isQuestLocked: Bool {
        calculateRemainingTimeUseCase.isQuestLocked(
            questOpenTime: questsEntity?.questOpenTime,
            currentTime: questsEntity?.currentTime
        )
    }
    var currentQuestIndexPath: IndexPath {
        var indexPath = IndexPath()
        
        for (sectionIndex, step) in steps.enumerated() {
            if let itemIndex = step.quests.firstIndex(where: { $0.questNumber == currentStep }) {
                indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                break
            }
        }
        return indexPath
    }
    
    func getStep(section: Int) -> StepEntity? {
        questsEntity?.steps[section]
    }
    
    func getQuestsCount(section: Int) -> Int {
        questsEntity?.steps[section].quests.count ?? 0
    }
    
    func getQuest(section: Int, item: Int) -> QuestEntity? {
        questsEntity?.steps[section].quests[item]
    }
    
    func getQuestState(questNumber: Int) -> QuestState {
        if questNumber < currentStep {
            return .completed
        }
        if questNumber > currentStep {
            return .locked
        }
        if isQuestLocked {
            let remainingSeconds = calculateRemainingTimeUseCase.calculateRemainingTime(
                questOpenTime: questsEntity?.questOpenTime,
                currentTime: questsEntity?.currentTime
            )
            let initialTime = calculateRemainingTimeUseCase.formatRemainingTime(seconds: remainingSeconds)
            return .upComing(initialTime)
        }
        return .ongoing
    }
}

extension QuestsViewModel: ViewModelType {
    
    enum Input {
        case questViewWillAppear
        case questOpen
    }
    
    struct Output {
        let namePublisher: AnyPublisher<Result<String, ByeBooError>, Never>
        let journeyPublisher: AnyPublisher<Result<JourneyEntity, ByeBooError>, Never>
        let questsPublisher: AnyPublisher<Result<ProgressingQuestsEntity, ByeBooError>, Never>
        let loadingPublisher: AnyPublisher<Bool, Never>
        let timePublisher: AnyPublisher<Result<String, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .questViewWillAppear:
            loadingSubject.send(true)
            getUseName()
            fetchUserJourney()
            fetchProgressingQuests()
        case .questOpen:
            fetchProgressingQuests()
        }
    }
}
