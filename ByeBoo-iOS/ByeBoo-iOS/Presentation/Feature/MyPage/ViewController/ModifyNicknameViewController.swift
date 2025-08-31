//
//  ModifyNicknameViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/21/25.
//

import Combine
import UIKit

final class ModifyNicknameViewController: BaseViewController {
    
    private let rootView = ModifyNicknameView()
    
    private let viewModel: ModifyNicknameViewModel
    private var cancellables = Set<AnyCancellable>()
            
    init(viewModel: ModifyNicknameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        bind()
        focusTextField()
    }
    
    override func setAddTarget() {
        rootView.confirmButton.addTarget(
            self,
            action: #selector(confirmButtonDidTap),
            for: .touchUpInside
        )
    }
    
    private func focusTextField() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.rootView.nicknameTextField.nicknameField.becomeFirstResponder()
        }
    }
}

extension ModifyNicknameViewController {
    
    @objc
    private func confirmButtonDidTap() {
        guard let name = rootView.nicknameTextField.nicknameField.text else { return }
        viewModel.action(.modifyNameDidTap(name))
    }
}

extension ModifyNicknameViewController: ToastPresentable, ToastErrorHandler {
    
    private func bind() {
        viewModel.output.nameResult
            .receive(on: DispatchQueue.main)
            .sink { result in
            switch result {
            case .success:
                self.back()
            case .failure(let error):
                self.handleError(error)
            }
        }.store(in: &cancellables)
    }
    
    func updateName(_ name: String?) {
        guard let name = name else { return }
        rootView.configure(name)
    }
}

extension ModifyNicknameViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}
