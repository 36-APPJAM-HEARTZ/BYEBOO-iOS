//
//  LookBackJourneyViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/20/25.
//

import Combine
import Foundation

final class LookBackJourneyViewModel {
    
    private var lookBackJourneySubject: PassthroughSubject<Result<[JourneyEntity], ByeBooError>, Never> = .init()
    
    var output: Output {
        Output(
            lookBackJourneyPublisher: lookBackJourneySubject.eraseToAnyPublisher()
        )
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let useCase: GetLookBackJourneyUseCase
    
    init(useCase: GetLookBackJourneyUseCase) {
        self.useCase = useCase
    }
}


extension LookBackJourneyViewModel {
    enum Input {
        case lookBackJourneyDidLoad
    }
    
    struct Output {
        let lookBackJourneyPublisher: AnyPublisher<Result<[JourneyEntity], ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .lookBackJourneyDidLoad:
            getLookBackJourneys()
        }
    }
}

extension LookBackJourneyViewModel {
    func getLookBackJourneys() {
        Task {
            do {
                let journeys = try await useCase.execute()
                lookBackJourneySubject.send(.success(journeys))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                ByeBooLogger.error(error as ByeBooError)
                lookBackJourneySubject.send(.failure(error))
            }
        }
    }
}
