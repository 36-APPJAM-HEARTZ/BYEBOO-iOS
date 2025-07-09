//
//  HomeOnboardingViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

final class HomeOnboardingViewController: BaseViewController {
    
    private let rootView = HomeOnboardingView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.startAnimation()
        setGesture()
    }
    
}

extension HomeOnboardingViewController {
    private func setGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longDidTap))
        longPressGesture.minimumPressDuration = 2
        rootView.characterImageView.addGestureRecognizer(longPressGesture)
        rootView.characterImageView.isUserInteractionEnabled = true
    }
    
    @objc
    private func longDidTap() {
        ByeBooLogger.debug("꾹 눌렀음")
        let viewController = BottomNavigationViewController()
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let window = windowScene.windows.first {

            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
}
