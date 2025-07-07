//
//  InformationViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/7/25.
//

import UIKit

final class InformationViewController: BaseViewController {
    
    private var informationView: InformationViewType
    private var progressBarType: ProgressBarType
    
    init(informationView: InformationViewType, progressBarType: ProgressBarType) {
        self.informationView = informationView
        self.progressBarType = progressBarType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var informationBaseView = InformationBaseView(
        progressBarType: progressBarType,
        informationView: informationView
    )
    
    override func loadView() {
        setTopNavigator()
        view = informationBaseView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if let inputNicknameView = informationBaseView.informationView as? InputNicknameView {
            inputNicknameView.nicknameTextField.setTextFieldStyle(.onBeginEditing)
        }
    }
    
    private func setTopNavigator() {
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .back,
            action: #selector(back)
        )
    }
}

extension InformationViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
