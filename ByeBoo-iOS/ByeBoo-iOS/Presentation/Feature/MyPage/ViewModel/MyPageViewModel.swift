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
    private var logoutResultSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private var withdrawResultSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    
    private(set) var output: Output

    private let getUserNameUseCase: GetUserNameUseCase
    private let logoutUseCase: LogoutUseCase
    private let withdrawUseCase: WithdrawUseCase
    
    init(
        getUserNameUseCase: GetUserNameUseCase,
        logoutUseCase: LogoutUseCase,
        withdrawUseCase: WithdrawUseCase
    ) {
        self.getUserNameUseCase = getUserNameUseCase
        self.logoutUseCase = logoutUseCase
        self.withdrawUseCase = withdrawUseCase
        
        output = Output(
            userResult: userResultSubject.eraseToAnyPublisher(),
            logoutResult: logoutResultSubject.eraseToAnyPublisher(),
            withdrawResult: withdrawResultSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear:
            getUserName()
        case .logoutActionButtonDidTap:
            logout()
        case .withdrawActionButtonDidTap:
            withdraw()
        }
    }
}

extension MyPageViewModel {
    enum Input {
        case viewWillAppear
        case logoutActionButtonDidTap
        case withdrawActionButtonDidTap
    }
    
    struct Output {
        let userResult: AnyPublisher<Result<String, ByeBooError>, Never>
        let logoutResult: AnyPublisher<Result<Void, ByeBooError>, Never>
        let withdrawResult: AnyPublisher<Result<Void, ByeBooError>, Never>
    }
}

extension MyPageViewModel {
    private func getUserName() {
        let name = getUserNameUseCase.execute()
        userResultSubject.send(.success(name))
    }
    
    private func logout() {
        Task {
            do {
                try await logoutUseCase.execute()
                logoutResultSubject.send(.success(()))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                ByeBooLogger.error(error as ByeBooError)
                logoutResultSubject.send(.failure(error))
            }
        }
    }
    
    private func withdraw() {
        Task {
            do {
                try await withdrawUseCase.execute()
                withdrawResultSubject.send(.success(()))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                ByeBooLogger.error(error as ByeBooError)
                withdrawResultSubject.send(.failure(error))
            }
        }
    }
}
