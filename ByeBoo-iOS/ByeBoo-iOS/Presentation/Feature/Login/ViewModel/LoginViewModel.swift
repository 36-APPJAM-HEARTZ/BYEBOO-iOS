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
    private var isRegisteredSubject: PassthroughSubject<Result<Bool, ByeBooError>, Never> = .init()
    private var getUserIDSubject: PassthroughSubject<Int, Never> = .init()
    private let keychainService = DefaultKeychainService()
    
    var output: Output {
        Output(
            isRegisteredPublisher: isRegisteredSubject.eraseToAnyPublisher(),
            userIDPublisher: getUserIDSubject.eraseToAnyPublisher()
        )
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let socialLoginUseCase: SocialLoginUseCase
    private let getIsRegisteredUseCase: GetIsRegisteredUseCase
    private let getUserIDUseCase: GetUserIDUseCase
    
    init(
        socialLoginUseCase: SocialLoginUseCase,
        getIsRegisteredUseCase: GetIsRegisteredUseCase,
        getUserIDUseCase: GetUserIDUseCase
    ) {
        self.socialLoginUseCase = socialLoginUseCase
        self.getIsRegisteredUseCase = getIsRegisteredUseCase
        self.getUserIDUseCase = getUserIDUseCase
    }
    
}

extension LoginViewModel {
    enum Input {
        case socialLoginButtonDidTap(platform: LoginPlatform)
    }
    
    struct Output {
        let isRegisteredPublisher: AnyPublisher<Result<Bool, ByeBooError>, Never>
        let userIDPublisher: AnyPublisher<Int, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .socialLoginButtonDidTap(let platform) :
            socialLogin(platform: platform)
        }
    }
}

extension LoginViewModel {
    private func socialLogin(platform: LoginPlatform) {
        Task {
            do {
                let _ = try await socialLoginUseCase.execute(platform: platform)
                socialLoginAuthSubject.send(.success(()))
                getIsRegistered()
                getUserID()
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
    
    private func getUserID() {
        let id = getUserIDUseCase.execute()
        getUserIDSubject.send(id ?? 0)
    }
}
