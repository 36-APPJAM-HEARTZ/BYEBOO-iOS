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
        let startTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(startButtonDidTap))
        rootView.startCardView.addGestureRecognizer(startTapRecognizer)
        rootView.startCardView.isUserInteractionEnabled = true
        
        let lookBackTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(lookBackButtonDidTap))
        rootView.lookBackCardView.addGestureRecognizer(lookBackTapRecognizer)
        rootView.lookBackCardView.isUserInteractionEnabled = true
    }
}

extension QuestInitViewController {
    @objc
    private func startButtonDidTap() {
        guard let viewModel = DIContainer.shared.resolve(type: NewJourneyViewModel.self) else {
            return
        }
        
        let viewController = NewJourneySelectViewController(viewModel: viewModel)
        
        guard let navigationController else {
            ByeBooLogger.error(ByeBooError.navigationControllerMissing)
            return
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func lookBackButtonDidTap() {
        guard let viewModel = DIContainer.shared.resolve(type: LookBackJourneyViewModel.self) else {
            return
        }
        
        let viewController = LookBackJourneyViewController(viewModel: viewModel)
        
        guard let navigationController else {
            ByeBooLogger.error(ByeBooError.navigationControllerMissing)
            return
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
