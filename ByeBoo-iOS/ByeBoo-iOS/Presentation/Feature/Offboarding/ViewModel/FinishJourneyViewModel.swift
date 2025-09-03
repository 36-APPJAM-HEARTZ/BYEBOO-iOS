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
    
    private let userNameSubject: PassthroughSubject<String, Never> = .init()
    
    init(getUserNameUseCase: GetUserNameUseCase) {
        self.getUserNameUseCase = getUserNameUseCase
        
        output = Output(userNamePublisher: userNameSubject.eraseToAnyPublisher()
        )
    }
}

extension FinishJourneyViewModel: ViewModelType {
    enum Input {
        case viewDidLoad
    }
    
    struct Output {
        let userNamePublisher: AnyPublisher<String, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            getUserName()
        }
    }
}

extension FinishJourneyViewModel {
    private func getUserName() {
        let name = getUserNameUseCase.execute()
        userNameSubject.send(name)
    }
}
