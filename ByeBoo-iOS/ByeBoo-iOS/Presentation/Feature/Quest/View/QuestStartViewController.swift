//
//  QuestStartViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/9/25.
//

import UIKit

final class QuestStartViewController: BaseViewController {
    
    private let rootView = QuestStartView(nickname: "하츠핑")
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .back,
            action: #selector(back)
        )
    }
    
    override func setAddTarget() {
        rootView.confirmButton.addTarget(
            self,
            action: #selector(questStartButtonDidTap),
            for: .touchUpInside
        )
    }
}

extension QuestStartViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension QuestStartViewController {
    
    @objc
    func questStartButtonDidTap() {
        // 퀘스트 
    }
}
