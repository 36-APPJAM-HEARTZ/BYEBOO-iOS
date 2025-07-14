//
//  QuestStartViewModel.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/14/25.
//

import Combine
import UIKit

final class QuestStartViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var output: Output
    
    private var startResultSubject = PassthroughSubject<Result<Bool, ByeBooError>, Never>()
    private var nameResultSubject = PassthroughSubject<Result<String, ByeBooError>, Never>()
    private var journeyResultSubject = PassthroughSubject<Result<JourneyEntity, ByeBooError>, Never>()
    
    
    private let startJourneyUseCase: StartJourneyUseCase
    private let getUserNameUseCase: GetUserNameUseCase
    private let fetchJourneyUseCase: FetchUserJourneyUseCase
    
    init(
        startJourneyUseCase: StartJourneyUseCase,
        getUserNameUseCase: GetUserNameUseCase,
        fetchJourneyUseCase: FetchUserJourneyUseCase
    ) {
        self.startJourneyUseCase = startJourneyUseCase
        self.getUserNameUseCase = getUserNameUseCase
        self.fetchJourneyUseCase = fetchJourneyUseCase
        
        output = Output(
            startResult: startResultSubject.eraseToAnyPublisher(),
            nameResult: nameResultSubject.eraseToAnyPublisher(),
            journeyResult: journeyResultSubject.eraseToAnyPublisher()
        )
    }
}

extension QuestStartViewModel: ViewModelType {
    
    enum Input {
        case viewDidLoad
        case buttonDidTap
    }
    
    struct Output {
        let startResult: AnyPublisher<Result<Bool, ByeBooError>, Never>
        let nameResult: AnyPublisher<Result<String, ByeBooError>, Never>
        let journeyResult: AnyPublisher<Result<JourneyEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchJourney()
            getUserName()
        case .buttonDidTap:
            startJourney()
        }
    }
}

extension QuestStartViewModel {
    private func startJourney() {
        Task {
            do {
                try await startJourneyUseCase.execute()
                startResultSubject.send(.success(true))
            } catch {
                startResultSubject.send(.failure(error as? ByeBooError ?? ByeBooError.unknownError))
            }
        }
    }
    
    private func fetchJourney() {
        Task {
            do {
                let journey = try await fetchJourneyUseCase.execute()
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
    
    private func getUserName() {
        let name = getUserNameUseCase.execute()
        nameResultSubject.send(.success(name))
    }
}


