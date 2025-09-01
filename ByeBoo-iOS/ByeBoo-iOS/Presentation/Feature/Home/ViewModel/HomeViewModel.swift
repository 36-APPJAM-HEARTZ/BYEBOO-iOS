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
    private var userResultSubject = CurrentValueSubject<String, Never>("하츠핑")
    private var isHelperShownResultSubject = CurrentValueSubject<Bool, Never>(true)
    private var homeStateResultSubject = PassthroughSubject<Result<UserQuestStatusEntity, ByeBooError>, Never>()
    private var journeyResultSubject = PassthroughSubject<Result<JourneyEntity, ByeBooError>, Never>()

    private let fetchCharacterDialogueUseCase: FetchCharacterDialogueUseCase
    private let fetchQuestStatusUseCase: FetchQuestStatusUseCase
    private let fetchUserJourneyUseCase: FetchUserJourneyUseCase
    private let getUserNameUseCase: GetUserNameUseCase
    private let setHelperUseCase: SetHelperUseCase
    private let getHelperUseCase: GetHelperUseCase
    
    init(
        fetchCharacterDialogueUseCase: FetchCharacterDialogueUseCase,
        fetchQuestStatusUseCase: FetchQuestStatusUseCase,
        fetchUserJourneyUseCase: FetchUserJourneyUseCase,
        getUserNameUseCase: GetUserNameUseCase,
        setHelperUseCase: SetHelperUseCase,
        getHelperUseCase: GetHelperUseCase
    ) {
        self.fetchCharacterDialogueUseCase = fetchCharacterDialogueUseCase
        self.fetchQuestStatusUseCase = fetchQuestStatusUseCase
        self.fetchUserJourneyUseCase = fetchUserJourneyUseCase
        self.getUserNameUseCase = getUserNameUseCase
        self.setHelperUseCase = setHelperUseCase
        self.getHelperUseCase = getHelperUseCase
        
        output = Output(
            characterResult: characterResultSubject.eraseToAnyPublisher(),
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
        let userResult: AnyPublisher<String, Never>
        let helperResult: AnyPublisher<Bool, Never>
        let homeStateResult: AnyPublisher<Result<UserQuestStatusEntity, ByeBooError>, Never>
        let journeyResult: AnyPublisher<Result<JourneyEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear:
            // TODO: 구조적 동시성 반영
            fetchDialogue()
            fetchStatus()
            fetchJourney()
            
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
    
    private func fetchStatus() {
        Task {
            do {
                let status = try await fetchQuestStatusUseCase.execute()
                homeStateResultSubject.send(.success(status))
                isHelperShown(state: status.currentStatus)
                ByeBooLogger.debug("home status: \(status)")
            } catch {
                if let error = error as? ByeBooError {
                    homeStateResultSubject.send(.failure(error))
                }
                isHelperShown(state: .beforeJourneyStart)
            }
        }
    }
    
    private func fetchJourney() {
        Task {
            do {
                let journey = try await fetchUserJourneyUseCase.execute()
                journeyResultSubject.send(.success(journey))
            } catch {
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
        userResultSubject.send(name)
    }
    
    private func isHelperShown(state: HomeState) {
        
        if !getHelperUseCase.execute() && state == .beforeJourneyStart {
            isHelperShownResultSubject.send(false)
        } else {
            isHelperShownResultSubject.send(true)
        }
    }
    
    private func setHelperShown() {
        setHelperUseCase.execute()
    }
}
