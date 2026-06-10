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
    private var hasEnterMyPageResultSubject: PassthroughSubject<Result<Bool, ByeBooError>, Never> = .init()
    private var alarmEnabledResultSubject: PassthroughSubject<Result<Bool, ByeBooError>, Never> = .init()
    
    private(set) var output: Output

    private let getUserNameUseCase: GetUserNameUseCase
    private let logoutUseCase: LogoutUseCase
    private let withdrawUseCase: WithdrawUseCase
    private let changeNotificationPermissionUseCase: ChangeNotificationPermissionUseCase
    private let checkHasEnterMyPageUseCase: CheckHasEnterMyPageUseCase
    private let checkAlarmEnabledUseCase: CheckAlarmEnabledUseCase
    
    init(
        getUserNameUseCase: GetUserNameUseCase,
        logoutUseCase: LogoutUseCase,
        withdrawUseCase: WithdrawUseCase,
        changeNotificationPermissionUseCase: ChangeNotificationPermissionUseCase,
        checkHasEnterMyPageUseCase: CheckHasEnterMyPageUseCase,
        checkAlarmEnabledUseCase: CheckAlarmEnabledUseCase
    ) {
        self.getUserNameUseCase = getUserNameUseCase
        self.logoutUseCase = logoutUseCase
        self.withdrawUseCase = withdrawUseCase
        self.changeNotificationPermissionUseCase = changeNotificationPermissionUseCase
        self.checkHasEnterMyPageUseCase = checkHasEnterMyPageUseCase
        self.checkAlarmEnabledUseCase = checkAlarmEnabledUseCase
        
        output = Output(
            userResult: userResultSubject.eraseToAnyPublisher(),
            logoutResult: logoutResultSubject.eraseToAnyPublisher(),
            withdrawResult: withdrawResultSubject.eraseToAnyPublisher(),
            notificationResult: notificationResultSubject.eraseToAnyPublisher(),
            hasEnterMyPageResult: hasEnterMyPageResultSubject.eraseToAnyPublisher(),
            alarmEnabledResult: alarmEnabledResultSubject.eraseToAnyPublisher()
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
        case .checkHasEnterMyPage:
            checkHasEnterMyPage()
        case .checkAlarmEnabled:
            checkAlarmEnabled()
        }
    }
}

extension MyPageViewModel {
    enum Input {
        case viewWillAppear
        case logoutActionButtonDidTap
        case withdrawActionButtonDidTap
        case notificationSwitchDidTap
        case checkHasEnterMyPage
        case checkAlarmEnabled
    }
    
    struct Output {
        let userResult: AnyPublisher<Result<String, ByeBooError>, Never>
        let logoutResult: AnyPublisher<Result<Void, ByeBooError>, Never>
        let withdrawResult: AnyPublisher<Result<Void, ByeBooError>, Never>
        let notificationResult: AnyPublisher<Result<Bool, ByeBooError>, Never>
        let hasEnterMyPageResult: AnyPublisher<Result<Bool, ByeBooError>, Never>
        let alarmEnabledResult: AnyPublisher<Result<Bool, ByeBooError>, Never>
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
                let _ = try await logoutUseCase.execute()
                logoutResultSubject.send(.success(()))
            } catch(let error as ByeBooError) {
                ByeBooLogger.error(error)
                logoutResultSubject.send(.failure(error))
            }
        }
    }
    
    private func withdraw() {
        Task {
            do {
                let _ = try await withdrawUseCase.execute()
                withdrawResultSubject.send(.success(()))
            } catch(let error as ByeBooError) {
                ByeBooLogger.error(error)
                withdrawResultSubject.send(.failure(error))
            }
        }
    }
    
    private func changeNotificationPermission() {
        Task {
            do {
                let result = try await changeNotificationPermissionUseCase.execute()
                notificationResultSubject.send(.success(result))
            } catch(let error as ByeBooError) {
                ByeBooLogger.error(error)
                notificationResultSubject.send(.failure(error))
            }
        }
    }
    
    private func checkHasEnterMyPage() {
        let result = checkHasEnterMyPageUseCase.execute()
        hasEnterMyPageResultSubject.send(.success(result))
    }
    
    private func checkAlarmEnabled() {
        let result = checkAlarmEnabledUseCase.execute()
        alarmEnabledResultSubject.send(.success(result))
    }
}
