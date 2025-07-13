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
    private var userResultSubject: PassthroughSubject<Result<String, ByeBooError>, Never> = .init()
    
    private(set) var output: Output

    private let fetchUserJourneyUseCase: FetchUserJourneyUseCase
    private let getUserNameUseCase: GetUserNameUseCase
    
    init(
        fetchUserJourneyUseCase: FetchUserJourneyUseCase,
        getUserNameUseCase: GetUserNameUseCase
    ) {
        self.fetchUserJourneyUseCase = fetchUserJourneyUseCase
        self.getUserNameUseCase = getUserNameUseCase
        
        output = Output(
            journeyResult: journeyResultSubject.eraseToAnyPublisher(),
            userResult: userResultSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchJourney()
            getUserName()
            
        }
    }
}

extension JourneyResultViewModel {
    enum Input {
        case viewDidLoad
    }
    
    struct Output {
        let journeyResult: AnyPublisher<Result<JourneyEntity, ByeBooError>, Never>
        let userResult: AnyPublisher<Result<String, ByeBooError>, Never>
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
    
    private func getUserName() {
        let name = getUserNameUseCase.execute()
        userResultSubject.send(.success(name))
    }
}
