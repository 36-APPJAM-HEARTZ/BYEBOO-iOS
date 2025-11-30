//
//  LoginViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/19/25.
//

import AuthenticationServices
import Combine
import UIKit

import Mixpanel

final class LoginViewController: BaseViewController {
    
    private let rootView = LoginView()
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    private var platform: LoginPlatform = .KAKAO
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view = rootView
        setAddTarget()
        rootView.startAnimation()
        bind()
    }
        
    override func setAddTarget() {
        rootView.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonDidTap) , for: .touchUpInside)
        rootView.appleLoginButton.addTarget(self, action: #selector(appleLoginButtonDidTap), for: .touchUpInside)
    }
}

extension LoginViewController{
    @objc
    private func kakaoLoginButtonDidTap() {
        self.platform = .KAKAO
        viewModel.action(.socialLoginButtonDidTap(platform: .KAKAO))
    }
    
    @objc
    private func appleLoginButtonDidTap() {
        self.platform = .APPLE
        viewModel.action(.socialLoginButtonDidTap(platform: .APPLE))
    }
}

extension LoginViewController {
    private func bind() {
        viewModel.output.isRegisteredPublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success(let isRegisterd):
                    ByeBooLogger.debug(isRegisterd)
                    let nextViewController: UIViewController
                    if isRegisterd {
                        nextViewController = ByeBooTabBar()
                    } else {
                        nextViewController = UINavigationController(rootViewController: ViewControllerFactory.shared.makeTermsViewController())
                    }
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                        
                        ViewControllerUtils.setRootViewController(
                            window: window,
                            viewController: nextViewController,
                            withAnimation: true
                        )
                    }
                    
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.userIDPublisher
            .sink { [weak self] id in
                Mixpanel.mainInstance().identify(distinctId: String(id))
                
                let property = CommonEvents.LoginProperty(
                    isLoginComplete: true,
                    logintype: self?.platform.mixpanelKey ?? LoginPlatform.KAKAO.mixpanelKey
                )
                Mixpanel.mainInstance().track(
                    event: CommonEvents.Name.login,
                    properties: property.dictionary
                )
            }
            .store(in: &cancellables)
    }
    
}
