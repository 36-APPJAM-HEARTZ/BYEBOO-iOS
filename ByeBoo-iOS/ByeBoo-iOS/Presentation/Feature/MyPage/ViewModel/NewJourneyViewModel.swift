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
    private var postJourneySubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    
    var output: Output {
        Output(
            newJourneyPublisher: newJourneySubject.eraseToAnyPublisher(),
            postJourneyPublisher: postJourneySubject.eraseToAnyPublisher()
        )
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let getNewJourneyUseCase: GetNewJourneyUseCase
    private let postJourneyUseCase: FetchNewJourneyUseCase
    
    init(
        getNewJourneyUseCase: GetNewJourneyUseCase,
        postJourneyUseCase: FetchNewJourneyUseCase
    ) {
        self.getNewJourneyUseCase = getNewJourneyUseCase
        self.postJourneyUseCase = postJourneyUseCase
    }
}

extension NewJourneyViewModel {
    enum Input {
        case newJourneyDidLoad
        case selectedJourneyDidTap(journey: String)
    }
    
    struct Output {
        let newJourneyPublisher: AnyPublisher<Result<LookBackJourneyEntity, ByeBooError>, Never>
        let postJourneyPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .newJourneyDidLoad:
            getNewJourneys()
        case .selectedJourneyDidTap(let journey):
            postNewJourneys(journey: journey)
        }
    }
}

extension NewJourneyViewModel {
    private func getNewJourneys() {
        Task {
            do {
                let journeys = try await getNewJourneyUseCase.execute()
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
    
    private func postNewJourneys(journey: String) {
        Task {
            do {
                let _ = try await postJourneyUseCase.execute(journey: JourneyType.titleToEnum(journey) ?? .face)
                postJourneySubject.send(.success(()))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                ByeBooLogger.error(error as ByeBooError)
                postJourneySubject.send(.failure((error)))
            }
        }
    }
}
