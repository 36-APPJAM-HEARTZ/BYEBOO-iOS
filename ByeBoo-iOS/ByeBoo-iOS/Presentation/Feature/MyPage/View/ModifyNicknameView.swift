//
//  ModifyNicknameView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/21/25.
//

import UIKit

final class ModifyNicknameView: BaseView {
    
    private let nicknameLabel = UILabel()
    private(set) var nicknameTextField = ByeBooNicknameTextField(.onBeginEditing)
    private(set) var nicknameStateView = NicknameStateView()
    private(set) var confirmButton = ByeBooButton(titleText: "완료하기", type: .disabled)
    
    init() {
        super.init(frame: .zero)
        
        setStyle()
        setUI()
        setLayout()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        nicknameLabel.applyByeBooFont (
            style: .body1Sb16,
            text: "닉네임",
            color: .grayscale300
        )
        
        nicknameTextField.do {
            $0.nicknameField.placeholder = ""
            $0.nicknameField.backgroundColor = .white5
        }
        
        nicknameStateView.do {
            $0.isHidden = true
        }
        
        confirmButton.do {
            $0.isHidden = true
        }
    }
    
    override func setUI() {
        addSubviews(
            nicknameLabel,
            nicknameTextField,
            nicknameStateView,
            confirmButton
        )
    }
    
    override func setLayout() {
        // iPhone Duo 대응: 오른쪽 세로 바(상태바, 탭 바)와 겹치지 않도록 좌우는 safe area 기준
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16.adjustedH)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24.adjustedW)
        }
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24.adjustedW)
        }
        nicknameStateView.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(36.adjustedH)
        }
    }
    
    private func setAction() {
        nicknameTextField.onStateChange = { [weak self] type in
            self?.nicknameStateView.updateNicknameState(type)
        }
        nicknameTextField.onRegex = { [weak self] condition in
            if condition {
                self?.confirmButton.updateType(.enabled)
                return
            }
            self?.confirmButton.updateType(.disabled)
        }
    }
}

extension ModifyNicknameView {
    
    func configure(_ name: String) {
        nicknameTextField.nicknameField.text = name
    }
}
