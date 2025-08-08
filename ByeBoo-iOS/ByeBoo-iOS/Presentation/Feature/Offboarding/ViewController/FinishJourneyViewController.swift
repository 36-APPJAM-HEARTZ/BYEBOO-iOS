//
//  FinishJourneyViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

final class FinishJourneyViewController: BaseViewController {

    let rootView = FinishJourneyView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func setAddTarget() {
        rootView.startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
        rootView.lookBackButton.addTarget(self, action: #selector(lookBackButtonDidTap), for: .touchUpInside)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(homeLabelDidTap))
        rootView.backHomeLabel.addGestureRecognizer(tapRecognizer)
        rootView.backHomeLabel.isUserInteractionEnabled = true
    }
}

extension FinishJourneyViewController {
    @objc
    private func startButtonDidTap() {
        ByeBooLogger.debug("starbuttontapped")
        let viewController = NewJourneySelectViewController()
        guard let navigationController else {
            ByeBooLogger.error(ByeBooError.navigationControllerMissing)
            return
        }
        navigationController.pushViewController(viewController, animated: false)
    }
    
    @objc
    private func lookBackButtonDidTap() {
        ByeBooLogger.debug("lookBackButtonTapped")
        let viewController = LookBackJourneyViewController()
        guard let navigationController else {
            ByeBooLogger.error(ByeBooError.navigationControllerMissing)
            return
        }
        navigationController.pushViewController(viewController, animated: false)
    }
    
    @objc
    private func homeLabelDidTap() {
        ByeBooLogger.debug("homeLabelTapped")
        guard let navigationController else {
            ByeBooLogger.error(ByeBooError.navigationControllerMissing)
            return
        }
        
        guard tabBarController?.viewControllers?[safe: 0] != nil else { return }
        navigationController.tabBarController?.selectedIndex = 0
    }
}
