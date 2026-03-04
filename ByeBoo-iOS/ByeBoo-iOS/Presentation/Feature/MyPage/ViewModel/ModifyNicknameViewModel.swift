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
    private var checkValidNameSubject = CurrentValueSubject<Bool, Never>(true)
    
    private(set) var output: Output
    
    private let checkValidNicknameUseCase: CheckValidNicknameUseCase
    private let isForbiddenWordUseCase: IsForbiddenWordUseCase
    private let modifyNicknameUseCase: ModifyNicknameUseCase
    
    init(
        checkValidNicknameUseCase: CheckValidNicknameUseCase,
        isForbiddenWordUseCase: IsForbiddenWordUseCase,
        modifyNicknameUseCase: ModifyNicknameUseCase
    ) {
        self.checkValidNicknameUseCase = checkValidNicknameUseCase
        self.isForbiddenWordUseCase = isForbiddenWordUseCase
        self.modifyNicknameUseCase = modifyNicknameUseCase
        
        output = Output(
            nameResult: userNameSubject.eraseToAnyPublisher(),
            checkValidNameResult: checkValidNameSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .editingNickname(let name):
            let isValidNickname = checkValidNicknameUseCase.isValidRegulation(nickname: name)
            checkValidNameSubject.send(isValidNickname)
        case .modifyNameDidTap(let name):
            modifyUserName(name: name)
        }
    }
}

extension ModifyNicknameViewModel {
    
    enum Input {
        case editingNickname(String)
        case modifyNameDidTap(String)
    }
    
    struct Output {
        let nameResult: AnyPublisher<Result<String, ByeBooError>, Never>
        let checkValidNameResult: AnyPublisher<Bool, Never>
    }
}

extension ModifyNicknameViewModel {
    
    private func modifyUserName(name: String) {
        if isForbiddenWordUseCase.execute(word: name) ||
           !checkValidNicknameUseCase.isPermitteed(nickname: name) {
            userNameSubject.send(.failure(.nicknameViolation))
            return
        }
        
        Task {
            do {
                let name = try await modifyNicknameUseCase.execute(name: name)
                userNameSubject.send(.success(name))
            } catch {
                userNameSubject.send(.failure(error as! ByeBooError))
            }
        }
    }
}
