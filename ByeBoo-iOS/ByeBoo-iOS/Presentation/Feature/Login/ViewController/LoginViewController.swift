//
//  LoginViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/19/25.
//

import AuthenticationServices
import Combine
import UIKit

final class LoginViewController: BaseViewController {
    
    private let rootView = LoginView()
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    
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
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action(.viewDidLoad)
    }
    
    override func setAddTarget() {
        rootView.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonDidTap) , for: .touchUpInside)
        rootView.appleLoginButton.addTarget(self, action: #selector(appleLoginButtonDidTap), for: .touchUpInside)
    }
}

extension LoginViewController{
    @objc
    private func kakaoLoginButtonDidTap() {
        viewModel.action(.socialLoginButtonDidTap(platform: .KAKAO))
    }
    
    @objc
    private func appleLoginButtonDidTap() {
        viewModel.action(.socialLoginButtonDidTap(platform: .APPLE))
    }
}

extension LoginViewController {
    private func bind() {
        viewModel.output.isRegisteredPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let isRegisterd):
                    ByeBooLogger.debug(isRegisterd)
                    let nextViewController: UIViewController
                    if isRegisterd {
                        nextViewController = BottomNavigationViewController()
                    } else {
                        nextViewController = ViewControllerFactory.shared.makeInformationViewController()
                    }
                    self?.navigationController?.setViewControllers([nextViewController], animated: false)
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellables)
    }
    
}
