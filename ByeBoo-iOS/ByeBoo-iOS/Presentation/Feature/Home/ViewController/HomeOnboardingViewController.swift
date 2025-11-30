//
//  HomeOnboardingViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

import Lottie
import Mixpanel

final class HomeOnboardingViewController: BaseViewController {
    
    private let rootView = HomeOnboardingView()
    private var pressStartTime: Date?
    
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
        rootView.characterLottie.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func longDidTap(_ gesture: UILongPressGestureRecognizer) {
                
        switch gesture.state {
        case .began:
            ByeBooLogger.debug("꾹 누르기 시작")
            pressStartTime = Date()
            rootView.characterLottie.pause()
            rootView.startPressAnimation()
        case .ended, .failed, .cancelled:
            ByeBooLogger.debug("꾹 누르기 종료")
            guard let start = pressStartTime else {
                rootView.revertPressAnimation()
                pressStartTime = nil
                return
            }
            
            let duration = Date().timeIntervalSince(start)
            
            if duration >= 0.3 {
                let tabBarController = ByeBooTabBar()
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                    let haptick = UINotificationFeedbackGenerator()
                    haptick.notificationOccurred(.success)
                    
                    ViewControllerUtils.setRootViewController(
                        window: window,
                        viewController: tabBarController,
                        withAnimation: true
                    )
                }
            } else {
                rootView.revertPressAnimation()
            }
            pressStartTime = nil
            
            Mixpanel.mainInstance().track(event: CommonEvents.Name.onboardingComplete)
        default:
            break
        }
    }
}
