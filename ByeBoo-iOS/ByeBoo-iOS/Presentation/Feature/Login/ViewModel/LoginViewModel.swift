//
//  LoginViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/26/25.
//

import AuthenticationServices
import Combine
import Foundation

final class LoginViewModel: NSObject {
        
    private var socialLoginAuthSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
//    private var postLoginSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private var isRegisteredSubject: PassthroughSubject<Result<Bool, ByeBooError>, Never> = .init()
    private let keychainService = DefaultKeychainService()
    
    var output: Output {
        Output(
            isRegisteredPublisher: isRegisteredSubject.eraseToAnyPublisher()
        )
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let socialLoginUseCase: SocialLoginUseCase
    private let getIsRegisteredUseCase: GetIsRegisteredUseCase
    private let tokenReissueUseCase: TokenReissueUseCase
    private let autoLoginUseCase: AutoLoginUseCase
    
    init(
        socialLoginUseCase: SocialLoginUseCase,
        getIsRegisteredUseCase: GetIsRegisteredUseCase,
        tokenReissueUseCase: TokenReissueUseCase,
        autoLoginUseCase: AutoLoginUseCase
    ) {
        self.socialLoginUseCase = socialLoginUseCase
        self.getIsRegisteredUseCase = getIsRegisteredUseCase
        self.tokenReissueUseCase = tokenReissueUseCase
        self.autoLoginUseCase = autoLoginUseCase
    }
    
}

extension LoginViewModel {
    enum Input {
        case viewDidLoad
        case socialLoginButtonDidTap(platform: LoginPlatform)
    }
    
    struct Output {
        let isRegisteredPublisher: AnyPublisher<Result<Bool, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            autoLogin()
        case .socialLoginButtonDidTap(let platform) :
            socialLogin(platform: platform)
        }
    }
}

extension LoginViewModel {
    private func autoLogin()  {
        if autoLoginUseCase.execute() {
            socialLoginAuthSubject.send(.success(()))
            getIsRegistered()
            ByeBooLogger.debug("자동로그인 성공")
        }
    }
    
    private func socialLogin(platform: LoginPlatform) {
        Task {
            do {
                let _ = try await socialLoginUseCase.execute(platform: platform)
                socialLoginAuthSubject.send(.success(()))
                getIsRegistered()
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                ByeBooLogger.error(error as ByeBooError)
                socialLoginAuthSubject.send(.failure(error))
            }
        }
    }
    
    private func getIsRegistered() {
        let isRegistered = getIsRegisteredUseCase.execute()
        isRegisteredSubject.send(.success(isRegistered))
    }
}
