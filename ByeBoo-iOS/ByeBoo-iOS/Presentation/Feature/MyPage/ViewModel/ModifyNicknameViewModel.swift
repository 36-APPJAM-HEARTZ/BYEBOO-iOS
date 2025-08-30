//
//  ModifyNicknameViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/25/25.
//

import Combine

final class ModifyNicknameViewModel: ViewModelType {
    
    private var cancellables = Set<AnyCancellable>()
    private var userNameSubject: PassthroughSubject<Result<String, ByeBooError>, Never> = .init()
    
    private(set) var output: Output
    
    private let useCase: ModifyNicknameUseCase
    
    init(useCase: ModifyNicknameUseCase) {
        self.useCase = useCase
        
        output = Output(
            nameResult: userNameSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .modifyNameDidTap(let name):
            modifyUserName(name: name)
        }
    }
}

extension ModifyNicknameViewModel {
    
    enum Input {
        case modifyNameDidTap(String)
    }
    
    struct Output {
        let nameResult: AnyPublisher<Result<String, ByeBooError>, Never>
    }
}

extension ModifyNicknameViewModel {
    
    private func modifyUserName(name: String) {
        Task {
            do {
                let name = try await useCase.execute(name: name)
                userNameSubject.send(.success(name))
            } catch {
                userNameSubject.send(.failure(error as! ByeBooError))
            }
        }
    }
}
