//
//  SplashViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 9/2/25.
//

import Combine
import UIKit

final class SplashViewController: BaseViewController {

    private let rootView = SplashView()
    private let viewModel: SplashViewModel
    private var cancellables = Set<AnyCancellable>()
    private var isFirstLaunch = true

    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view = rootView
        viewModel.action(.viewDidLoad)
        bind()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            guard let self = self else { return }
            if self.cancellables.isEmpty {
                timeoutFallback()
            }
        }
    }
}

extension SplashViewController {
    private func bind() {
        bindCheckForceUpdate()
        bindAutoLogin()
    }
    
    private func bindCheckForceUpdate() {
        viewModel.output.forceUpdatePublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case true:
                    self.presentForceUpdateModal()
                case false:
                    self.viewModel.action(.tryAutoLogin)
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindAutoLogin() {
        viewModel.output.autoLoginPublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        let nextViewController = ByeBooTabBar()
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                            
                            ViewControllerUtils.setRootViewController(
                                window: window,
                                viewController: nextViewController,
                                withAnimation: true
                            )
                        }
                    }
                case .failure(_):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        let nextViewController = ViewControllerFactory.shared.makeLoginViewController()
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                            
                            ViewControllerUtils.setRootViewController(
                                window: window,
                                viewController: nextViewController,
                                withAnimation: true
                            )
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func presentForceUpdateModal() {
        let modal = ModalBuilder(
            modalView: ForceUpdateModalView(),
            action: openAppstore,
            rootViewController: self
        )
        modal.present()
    }
    
    private func openAppstore() {
        guard let url = URL(string: AppConstants.appStoreURL) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc
    private func appDidBecomeActive() {
        guard !isFirstLaunch else {
            isFirstLaunch = false
            return
        }
        viewModel.action(.viewDidLoad)
    }
}

extension SplashViewController {
    private func timeoutFallback() {
        let nextViewController = ViewControllerFactory.shared.makeLoginViewController()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            ViewControllerUtils.setRootViewController(
                window: window,
                viewController: nextViewController,
                withAnimation: true
            )
        }
    }
}
