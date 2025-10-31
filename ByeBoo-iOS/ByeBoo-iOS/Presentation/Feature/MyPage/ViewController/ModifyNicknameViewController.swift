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
        rootView.nicknameTextField.onTextChange = { [weak self] text in
            guard let self = self else { return }
            
            self.rootView.do {
                $0.nicknameStateView.isHidden = false
                $0.nicknameStateView.letterCountLabel.text = "\(text.count)/\(5)"
                $0.confirmButton.isHidden = false
            }
            self.viewModel.action(.editingNickname(text))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
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
    
    func updateName(_ name: String?) {
        guard let name = name else { return }
        rootView.configure(name)
    }
    
    private func bind() {
        bindModifyNameResult()
        bindNicknameValidation()
    }
    
    private func bindModifyNameResult() {
        viewModel.output.nameResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.back()
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindNicknameValidation() {
        viewModel.output.checkValidNameResult
            .sink { [weak self] result in
                guard let text = self?.rootView.nicknameTextField.nicknameField.text else {
                    return
                }
                self?.rootView.nicknameTextField.changeNicknameState(text: text, isValid: result)
            }
            .store(in: &cancellables)
    }
}

extension ModifyNicknameViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}
