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
    private func longDidTap(_ gesture: UILongPressGestureRecognizer) {
        
        guard gesture.state == .began else { return }
        
        ByeBooLogger.debug("꾹 눌렀음")
        
        let tabBarController = BottomNavigationViewController()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            ViewControllerUtils.setRootViewController(
                window: window,
                viewController: tabBarController,
                withAnimation: true
            )
        }
    }
}
