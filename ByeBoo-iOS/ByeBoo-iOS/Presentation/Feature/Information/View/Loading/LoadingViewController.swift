//
//  LoadingViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/9/25.
//

import UIKit

final class LoadingViewController: BaseViewController {
    
    var nickname: String? {
        didSet {
            if let nickname = nickname {
                rootView.updateNickname(nickname)
            }
        }
    }
    private let rootView = LoadingView(nickname: "")
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let viewController = ViewControllerFactory.shared.makeCardJourneyViewController()
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
}
