//
//  NewJourneyViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/21/25.
//

import Combine
import Foundation

final class NewJourneyViewModel {
    
    private var newJourneySubject: PassthroughSubject<Result<LookBackJourneyEntity, ByeBooError>, Never> = .init()
    
    var output: Output {
        Output(
            newJourneyPublisher: newJourneySubject.eraseToAnyPublisher()
        )
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let useCase: GetNewJourneyUseCase
    
    init(useCase: GetNewJourneyUseCase) {
        self.useCase = useCase
    }
}

extension NewJourneyViewModel {
    enum Input {
        case newJourneyDidLoad
    }
    
    struct Output {
        let newJourneyPublisher: AnyPublisher<Result<LookBackJourneyEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .newJourneyDidLoad:
            getNewJourneys()
        }
    }
}

extension NewJourneyViewModel {
    func getNewJourneys() {
        Task {
            do {
                let journeys = try await useCase.execute()
                newJourneySubject.send(.success(journeys))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                ByeBooLogger.error(error as ByeBooError)
                newJourneySubject.send(.failure(error))
            }
        }
    }
}
