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
    
    private let startJourneyUseCase: StartJourneyUseCase
    
    init(startJourneyUseCase: StartJourneyUseCase) {
        self.startJourneyUseCase = startJourneyUseCase
        
        output = Output(startResult: startResultSubject.eraseToAnyPublisher())
    }
}

extension QuestStartViewModel: ViewModelType {
    
    enum Input {
        case buttonDidTap
    }
    
    struct Output {
        let startResult: AnyPublisher<Result<Bool, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
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
}


