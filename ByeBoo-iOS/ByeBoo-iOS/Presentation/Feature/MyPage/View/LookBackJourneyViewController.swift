//
//  LookBackJourneyViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

final class LookBackJourneyViewController: BaseViewController {
    
    private let rootView = LookBackJourneyView(journeyList: [Journey.stub()])
    
    override func loadView() {
        view = rootView
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
}

extension LookBackJourneyViewController: BackNavigable {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
