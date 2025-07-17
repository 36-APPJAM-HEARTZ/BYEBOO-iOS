//
//  NewJourneySelectViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

final class NewJourneySelectViewController: BaseViewController {
    
    private let rootView = NewJourneySelectView(unCompleteJourneyList: [JourneyEntity.stub()], completeJourneyList: [JourneyEntity.stub()])
    
    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .back(),
            action: #selector(back)
        )
    }
}

extension NewJourneySelectViewController: BackNavigable {
    func back() {
        guard let navigationController else {
            ByeBooLogger.error(ByeBooError.navigationControllerMissing)
            return
        }
        
        navigationController.popViewController(animated: true)
    }
}
