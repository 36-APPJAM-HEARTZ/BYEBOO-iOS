//
//  JourneyResultViewModel.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

import Combine
import Foundation

final class JourneyResultViewModel: ViewModelType {
    
    private var cancellables = Set<AnyCancellable>()
    private var journeyResultSubject: PassthroughSubject<Result<JourneyEntity, ByeBooError>, Never> = .init()
    
    private(set) var output: Output

    private let fetchUserJourneyUseCase: FetchUserJourneyUseCase
    
    init(fetchUserJourneyUseCase: FetchUserJourneyUseCase) {
        self.fetchUserJourneyUseCase = fetchUserJourneyUseCase
        
        output = Output(journeyResult: journeyResultSubject.eraseToAnyPublisher())
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchJourney()
        }
    }
}

extension JourneyResultViewModel {
    enum Input {
        case viewDidLoad
    }
    
    struct Output {
        let journeyResult: AnyPublisher<Result<JourneyEntity, ByeBooError>, Never>
    }
}

extension JourneyResultViewModel {
    private func fetchJourney() {
        Task {
            do {
                let journey = try await fetchUserJourneyUseCase.execute()
                
                journeyResultSubject.send(.success(journey))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                journeyResultSubject.send(.failure(error))
            }
        }
    }
}
