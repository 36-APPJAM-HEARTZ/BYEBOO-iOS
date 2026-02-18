//
//  AIAnswerViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 2/18/26.
//

import Combine
import UIKit

final class AIAnswerViewController: BaseViewController {
    
    private let rootView = AIAnswerView(answerState: .fail)
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .close(header: .black),
            action: #selector(close)
        )
    }
}

extension AIAnswerViewController: Dismissible {
    func close() {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: false)
    }
}

extension AIAnswerViewController {
    func configure( ) { }
}
