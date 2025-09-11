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
        setAddTarget()
    }
}

extension SplashViewController {
    
    private func bind() {
        viewModel.output.autoLoginPublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success:
                    let nextViewController = BottomNavigationViewController()
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                        
                        ViewControllerUtils.setRootViewController(
                            window: window,
                            viewController: nextViewController,
                            withAnimation: true
                        )
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
}
