//
//  FinishJourneyViewModel.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 9/3/25.
//

import Foundation
import Combine

final class FinishJourneyViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var output: Output
    
    private let getUserNameUseCase: GetUserNameUseCase
    private let getLastJourneyUseCase: GetLastJourneyUseCase
    
    private let userNameSubject: PassthroughSubject<String, Never> = .init()
    private let lastJourneySubject: PassthroughSubject<String, Never> = .init()
    
    init(
        getUserNameUseCase: GetUserNameUseCase,
        getLastJourneyUseCase: GetLastJourneyUseCase
    ) {
        self.getUserNameUseCase = getUserNameUseCase
        self.getLastJourneyUseCase = getLastJourneyUseCase
        
        output = Output(
            userNamePublisher: userNameSubject.eraseToAnyPublisher(),
            lastJourneyPublisher: lastJourneySubject.eraseToAnyPublisher()
        )
    }
}

extension FinishJourneyViewModel: ViewModelType {
    enum Input {
        case viewDidLoad
    }
    
    struct Output {
        let userNamePublisher: AnyPublisher<String, Never>
        let lastJourneyPublisher: AnyPublisher<String, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            getUserName()
            getLastJourney()
        }
    }
}

extension FinishJourneyViewModel {
    private func getUserName() {
        let name = getUserNameUseCase.execute()
        userNameSubject.send(name)
    }
    
    private func getLastJourney() {
        let journey = getLastJourneyUseCase.execute()
        lastJourneySubject.send(journey.title)
    }
}
