//
//  CommonQuestHistoryViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import UIKit

final class CommonQuestHistoryViewController: BaseViewController {
    
    private let rootView = CommonQuestHistoryView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .backAndMenu(header: .black),
            action: #selector(back),
            secondAction: #selector(bottomUp)
        )
    }
}

extension CommonQuestHistoryViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension CommonQuestHistoryViewController {
    
    @objc
    private func bottomUp() {
        
    }
}

extension CommonQuestHistoryViewController {
    
    func configure(
        question: String,
        writtenAt: Date,
        profileIcon: UIImage? = nil,
        nickname: String? = nil,
        content: String
    ) {
        rootView.configure(
            question: question,
            writtenAt: writtenAt,
            profileIcon: profileIcon,
            nickname: nickname,
            content: content
        )
    }
}
