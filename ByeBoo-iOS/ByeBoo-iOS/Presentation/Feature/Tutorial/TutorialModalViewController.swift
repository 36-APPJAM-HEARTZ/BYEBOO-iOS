//
//  TutorialModalViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/23/25.
//

final class TutorialModalViewController: BaseViewController {
    
    private let rootView = TutorialModalView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .close(header: .black),
            action: #selector(back)
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .none(),
            action: #selector(back)
        )
    }
}

extension TutorialModalViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}
