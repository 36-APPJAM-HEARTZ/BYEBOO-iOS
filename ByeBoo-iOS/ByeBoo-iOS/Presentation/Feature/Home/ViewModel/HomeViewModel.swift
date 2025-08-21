//
//  HomeViewModel.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/13/25.
//

import Combine
import Foundation

final class HomeViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var output: Output
    private var characterResultSubject = PassthroughSubject<Result<String, ByeBooError>, Never>()
    private var countResultSubject = PassthroughSubject<Result<Int, ByeBooError>, Never>()
    private var userResultSubject = CurrentValueSubject<String, Never>("하츠핑")
    private var isHelperShownResultSubject = CurrentValueSubject<Bool, Never>(true)
    private var homeStateResultSubject = PassthroughSubject<Result<HomeState, ByeBooError>, Never>()
    private var journeyResultSubject = PassthroughSubject<Result<JourneyEntity, ByeBooError>, Never>()

    private let fetchCharacterDialogueUseCase: FetchCharacterDialogueUseCase
    private let fetchCompleteQuestCountUseCase: FetchCompleteQuestCountUseCase
    private let fetchUserJourneyUseCase: FetchUserJourneyUseCase
    private let getUserNameUseCase: GetUserNameUseCase
    private let setHelperUseCase: SetHelperUseCase
    private let getHelperUseCase: GetHelperUseCase
    
    init(
        fetchCharacterDialogueUseCase: FetchCharacterDialogueUseCase,
        fetchCompleteQuestCountUseCase: FetchCompleteQuestCountUseCase,
        fetchUserJourneyUseCase: FetchUserJourneyUseCase,
        getUserNameUseCase: GetUserNameUseCase,
        setHelperUseCase: SetHelperUseCase,
        getHelperUseCase: GetHelperUseCase
    ) {
        self.fetchCharacterDialogueUseCase = fetchCharacterDialogueUseCase
        self.fetchCompleteQuestCountUseCase = fetchCompleteQuestCountUseCase
        self.fetchUserJourneyUseCase = fetchUserJourneyUseCase
        self.getUserNameUseCase = getUserNameUseCase
        self.setHelperUseCase = setHelperUseCase
        self.getHelperUseCase = getHelperUseCase
        
        output = Output(
            characterResult: characterResultSubject.eraseToAnyPublisher(),
            countResult: countResultSubject.eraseToAnyPublisher(),
            userResult: userResultSubject.eraseToAnyPublisher(),
            helperResult: isHelperShownResultSubject.eraseToAnyPublisher(),
            homeStateResult: homeStateResultSubject.eraseToAnyPublisher(),
            journeyResult: journeyResultSubject.eraseToAnyPublisher()
        )
    }
}

extension HomeViewModel: ViewModelType {
    enum Input {
        case viewWillAppear
        case helperTapped
    }
    
    struct Output {
        let characterResult: AnyPublisher<Result<String, ByeBooError>, Never>
        let countResult: AnyPublisher<Result<Int, ByeBooError>, Never>
        let userResult: AnyPublisher<String, Never>
        let helperResult: AnyPublisher<Bool, Never>
        let homeStateResult: AnyPublisher<Result<HomeState, ByeBooError>, Never>
        let journeyResult: AnyPublisher<Result<JourneyEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear:
            // TODO: 구조적 동시성 반영
            fetchDialogue()
            fetchCount()
            getUserResult()
        case .helperTapped:
            setHelperShown()
        }
    }
}

extension HomeViewModel {
    private func fetchDialogue() {
        Task {
            do {
                let dialogue = try await fetchCharacterDialogueUseCase.execute()
                characterResultSubject.send(.success(dialogue))
            } catch {
                characterResultSubject.send(
                    .failure(
                        error as? ByeBooError ?? ByeBooError.unknownError
                    )
                )
            }
        }
    }
    
    private func fetchCount() {
        Task {
            do {
                let count = try await fetchCompleteQuestCountUseCase.execute()
                homeStateResultSubject.send(.success(.beforeQuest))
                countResultSubject.send(.success(count))
            } catch {
                if let error = error as? ByeBooError {
                    switch error {
                    case .notFoundQuest:
                        fetchJourney()
                    default:
                        countResultSubject.send(.failure(error))
                    }
                }
            }
        }
    }
    
    private func fetchJourney() {
        Task {
            do {
                let journey = try await fetchUserJourneyUseCase.execute()
                homeStateResultSubject.send(.success(.beforeJourneyStart))
                journeyResultSubject.send(.success(journey))
            } catch {
                homeStateResultSubject.send(
                    .failure(
                        error as? ByeBooError ?? ByeBooError.unknownError
                    )
                )
                journeyResultSubject.send(
                    .failure(
                        error as? ByeBooError ?? ByeBooError.unknownError
                    )
                )
            }
        }
    }
    
    private func getUserResult() {
        let name = getUserNameUseCase.execute()
        let isHelperShown = getHelperUseCase.execute()
        ByeBooLogger.debug("isHelperShown: \(isHelperShown)")
        userResultSubject.send(name)
        isHelperShownResultSubject.send(isHelperShown)
    }
    
    private func setHelperShown() {
        setHelperUseCase.execute()
    }
}
