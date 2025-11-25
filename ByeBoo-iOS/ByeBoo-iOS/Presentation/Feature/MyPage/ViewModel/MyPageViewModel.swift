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
    private var notificationResultSubject: PassthroughSubject<Result<Bool, ByeBooError>, Never> = .init()
    
    private(set) var output: Output

    private let getUserNameUseCase: GetUserNameUseCase
    private let logoutUseCase: LogoutUseCase
    private let withdrawUseCase: WithdrawUseCase
    private let changeNotificationPermissionUseCase: ChangeNotificationPermissionUseCase
    
    init(
        getUserNameUseCase: GetUserNameUseCase,
        logoutUseCase: LogoutUseCase,
        withdrawUseCase: WithdrawUseCase,
        changeNotificationPermissionUseCase: ChangeNotificationPermissionUseCase
    ) {
        self.getUserNameUseCase = getUserNameUseCase
        self.logoutUseCase = logoutUseCase
        self.withdrawUseCase = withdrawUseCase
        self.changeNotificationPermissionUseCase = changeNotificationPermissionUseCase
        
        output = Output(
            userResult: userResultSubject.eraseToAnyPublisher(),
            logoutResult: logoutResultSubject.eraseToAnyPublisher(),
            withdrawResult: withdrawResultSubject.eraseToAnyPublisher(),
            notificationResult: notificationResultSubject.eraseToAnyPublisher()
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
        case .notificationSwitchDidTap:
            changeNotificationPermission()
        }
    }
}

extension MyPageViewModel {
    enum Input {
        case viewWillAppear
        case logoutActionButtonDidTap
        case withdrawActionButtonDidTap
        case notificationSwitchDidTap
    }
    
    struct Output {
        let userResult: AnyPublisher<Result<String, ByeBooError>, Never>
        let logoutResult: AnyPublisher<Result<Void, ByeBooError>, Never>
        let withdrawResult: AnyPublisher<Result<Void, ByeBooError>, Never>
        let notificationResult: AnyPublisher<Result<Bool, ByeBooError>, Never>
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
    
    private func changeNotificationPermission() {
        Task {
            do {
                let result = try await changeNotificationPermissionUseCase.execute()
                notificationResultSubject.send(.success(result))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                ByeBooLogger.error(error as ByeBooError)
                notificationResultSubject.send(.failure(error))
            }
        }
    }
}
