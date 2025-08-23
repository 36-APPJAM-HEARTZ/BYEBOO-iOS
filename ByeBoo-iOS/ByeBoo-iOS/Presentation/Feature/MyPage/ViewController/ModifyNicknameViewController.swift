//
//  ModifyNicknameViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/21/25.
//

final class ModifyNicknameViewController: BaseViewController {
    
    private let rootView = ModifyNicknameView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .titleAndBack("프로필 수정", header: .clear),
            action: #selector(back)
        )
    }
    
    override func setAddTarget() {
        rootView.confirmButton.addTarget(
            self,
            action: #selector(back),
            for: .touchUpInside
        )
    }
}

extension ModifyNicknameViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension ModifyNicknameViewController {
    
    func deliverName(_ name: String?) {
        guard let name = name else { return }
        rootView.updateName(name)
    }
}
