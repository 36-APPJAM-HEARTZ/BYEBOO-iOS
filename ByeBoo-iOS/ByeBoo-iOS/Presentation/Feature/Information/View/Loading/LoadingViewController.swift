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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            guard let viewModel = DIContainer.shared.resolve(type: JourneyResultViewModel.self) else {
                ByeBooLogger.error(ByeBooError.DIFailedError)
                fatalError()
            }
            
            let resultViewController = JourneyResultViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(resultViewController, animated: true)
            self.navigationController?.navigationBar.isHidden = true
        }
    }
}
