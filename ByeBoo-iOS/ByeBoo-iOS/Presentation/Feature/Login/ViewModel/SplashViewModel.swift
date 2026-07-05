//
//  SplashViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 9/2/25.
//

import Combine
import Foundation

final class SplashViewModel {

    private var autoLoginSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private var forceUpdateSubject: PassthroughSubject<Bool, Never> = .init()

    var output: Output {
        Output(
            autoLoginPublisher: autoLoginSubject.eraseToAnyPublisher(),
            forceUpdatePublisher: forceUpdateSubject.eraseToAnyPublisher()
        )
    }

    private var cancellables = Set<AnyCancellable>()
    private let autoLoginUseCase: AutoLoginUseCase
    private let checkForceUpdateUseCase: CheckForceUpdateUseCase

    init(
        autoLoginUseCase: AutoLoginUseCase,
        checkForceUpdateUseCase: CheckForceUpdateUseCase
    ) {
        self.autoLoginUseCase = autoLoginUseCase
        self.checkForceUpdateUseCase = checkForceUpdateUseCase
    }
}


extension SplashViewModel {
    enum Input {
        case viewDidLoad
        case tryAutoLogin
    }
    
    struct Output {
        let autoLoginPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
        let forceUpdatePublisher: AnyPublisher<Bool, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            checkForceUpdate()
        case .tryAutoLogin:
            autoLogin()
        }
    }
    
}

extension SplashViewModel {
    private func checkForceUpdate() {
        Task {
            do {
                if await checkForceUpdateUseCase.execute() {
                    forceUpdateSubject.send(true)
                    ByeBooLogger.debug("강제 업데이트 필요")
                } else {
                    forceUpdateSubject.send(false)
                }
            }
        }
    }
    
    private func autoLogin()  {
        ByeBooLogger.debug("자동로그인 실행")
        Task {
            do {
                if try await autoLoginUseCase.execute() {
                    autoLoginSubject.send(.success(()))
                    ByeBooLogger.debug("자동로그인 성공")
                }
                else {
                    ByeBooLogger.debug("자동로그인 실패")
                    autoLoginSubject.send(.failure((.noData)))
                }
            } catch(let error as ByeBooError) {
                autoLoginSubject.send(.failure((.noData)))
                ByeBooLogger.debug(ByeBooError.networkConnect)
                ByeBooLogger.error(error)
            }
        }
    }
}
