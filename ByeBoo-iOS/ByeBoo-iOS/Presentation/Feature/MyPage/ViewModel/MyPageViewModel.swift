//
//  MyPageViewModel.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/14/25.
//

import Combine
import Foundation

final class MyPageViewModel: ViewModelType {
    
    private var cancellables = Set<AnyCancellable>()
    private var userResultSubject: PassthroughSubject<Result<String, ByeBooError>, Never> = .init()
    
    private(set) var output: Output

    private let getUserNameUseCase: GetUserNameUseCase
    
    init(
        getUserNameUseCase: GetUserNameUseCase
    ) {
        self.getUserNameUseCase = getUserNameUseCase
        
        output = Output(
            userResult: userResultSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            getUserName()
            
        }
    }
}

extension MyPageViewModel {
    enum Input {
        case viewDidLoad
    }
    
    struct Output {
        let userResult: AnyPublisher<Result<String, ByeBooError>, Never>
    }
}

extension MyPageViewModel {
    private func getUserName() {
        let name = getUserNameUseCase.execute()
        userResultSubject.send(.success(name))
    }
}
