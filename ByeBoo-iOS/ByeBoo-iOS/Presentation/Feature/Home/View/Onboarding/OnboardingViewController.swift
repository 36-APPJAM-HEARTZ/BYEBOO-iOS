//
//  OnboardingViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

import UIKit

final class OnboardingViewController: BaseViewController {

    private let rootView = OnboardingView()
 
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func setAddTarget() {
        rootView.nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
    
    private func setGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(skipButtonDidTap))
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false
        rootView.headerView.skipStackView.addGestureRecognizer(tapGestureRecognizer)
    }

}

extension OnboardingViewController {
    @objc
    private func nextButtonDidTap() {
        switch rootView.step {
        case .first:
            rootView.step = .second
        case .second:
            rootView.step = .third
        case .third:
            pushViewController()
        }
    }
    
    @objc
    private func skipButtonDidTap() {
        pushViewController()
    }
    
    private func pushViewController() {
        guard let viewModel = DIContainer.shared.resolve(type: InformationViewModel.self) else {
            ByeBooLogger.error(ByeBooError.DIFailedError)
            fatalError()
        }
        let viewController = InformationViewController(viewModel: viewModel)
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = .fade
        navigationController?.view.layer.add(transition, forKey: nil)
        
        navigationController?.pushViewController(viewController, animated: false)
    }
}
