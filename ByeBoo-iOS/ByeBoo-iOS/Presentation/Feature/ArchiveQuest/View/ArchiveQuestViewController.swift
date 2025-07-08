//
//  ArchiveQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

final class ArchiveQuestViewController: BaseViewController {
    
    private let rootView = ArchiveQuestView()
    
    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .close,
            action: #selector(close)
        )
    }
    
}

extension ArchiveQuestViewController: Dismissible {
    func close() {
        //
    }
}
