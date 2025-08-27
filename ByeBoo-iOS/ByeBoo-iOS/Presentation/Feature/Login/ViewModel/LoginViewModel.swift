//
//  LoginViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/26/25.
//

import Combine
import Foundation

final class LoginViewModel {
    
    private var kakaoLoginAuthSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private var postLoginSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private var isRegisteredSubject: PassthroughSubject<Result<Bool, ByeBooError>, Never> = .init()
    
    var output: Output {
        Output(
            isRegisteredPublisher: isRegisteredSubject.eraseToAnyPublisher()
        )
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let kakaoLoginUseCase: KakaoLoginUseCase
    private let postLoginUseCase: PostLoginUseCase
    private let getIsRegisteredUseCase: GetIsRegisteredUseCase
    
    init(
        kakaoLoginUseCase: KakaoLoginUseCase,
        postLoginUseCase: PostLoginUseCase,
        getIsRegisteredUseCase: GetIsRegisteredUseCase
    ) {
        self.kakaoLoginUseCase = kakaoLoginUseCase
        self.postLoginUseCase = postLoginUseCase
        self.getIsRegisteredUseCase = getIsRegisteredUseCase
    }
    
}

extension LoginViewModel {
    enum Input {
        case kakaoLoginButtonDidTap
        case appleLoginButtonDidTap
    }
    
    struct Output {
        let isRegisteredPublisher: AnyPublisher<Result<Bool, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .kakaoLoginButtonDidTap:
            kakaoLogin()
        case .appleLoginButtonDidTap:
            appleLogin()
        }
    }
}

extension LoginViewModel {
    private func kakaoLogin() {
        Task {
            do {
                let _ = try await kakaoLoginUseCase.execute(platform: .KAKAO)
                kakaoLoginAuthSubject.send(.success(()))
                getIsRegistered()
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                ByeBooLogger.error(error as ByeBooError)
                kakaoLoginAuthSubject.send(.failure(error))
            }
        }
    }
    
    private func appleLogin() {
        
    }
    
    private func getIsRegistered() {
        let isRegistered = getIsRegisteredUseCase.execute()
        isRegisteredSubject.send(.success(isRegistered))
    }
}
