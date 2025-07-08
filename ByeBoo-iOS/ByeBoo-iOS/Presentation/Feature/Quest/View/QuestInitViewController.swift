//
//  QuestInitViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

final class QuestInitViewController: BaseViewController {

    private let rootView = QuestInitView()
    
    override func loadView() {
        view = rootView
    }
    
    override func setAddTarget() {
        let startTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(startButtonTapped))
        rootView.startCardView.addGestureRecognizer(startTapRecognizer)
        rootView.startCardView.isUserInteractionEnabled = true
        
        let lookBackTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(lookBackButtonTapped))
        rootView.lookBackCardView.addGestureRecognizer(lookBackTapRecognizer)
        rootView.lookBackCardView.isUserInteractionEnabled = true
    }
}

extension QuestInitViewController {
    @objc
    private func startButtonTapped() {
        let viewController = NewJourneySelectViewController()
        
        guard let navigationController else {
            ByeBooLogger.error(ByeBooError.navigationControllerMissing)
            return
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func lookBackButtonTapped() {
        let viewController = LookBackJourneyViewController()
        
        guard let navigationController else {
            ByeBooLogger.error(ByeBooError.navigationControllerMissing)
            return
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
