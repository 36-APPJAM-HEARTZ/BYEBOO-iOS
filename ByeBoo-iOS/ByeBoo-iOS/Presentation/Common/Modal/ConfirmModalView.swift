//
//  ConfirmModalView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/24/25.
//

import UIKit

enum ConfirmModalType {
    case logout
    case withdraw
    
    var title: String {
        switch self {
        case .logout:
            return "로그아웃하시겠어요?"
        case .withdraw:
            return "정말 탈퇴하시겠어요?"
        }
    }
    
    var description: String? {
        switch self {
        case .logout:
            return nil
        case .withdraw:
            return "탈퇴 시 모든 데이터가 삭제됩니다."
        }
    }
}

final class ConfirmModalView: BaseView, ModalProtocol {
    var modalType: ConfirmModalType?
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let buttonStackView = UIStackView()
    let dismissButton: ByeBooButton?
    let actionButton: ByeBooButton
    
    init(
        modalType: ConfirmModalType,
        dismissButton: ByeBooButton?,
        actionButton: ByeBooButton
    ) {
        self.modalType = modalType
        self.titleLabel.text = modalType.title
        self.descriptionLabel.text = modalType.description
        self.dismissButton = dismissButton
        self.actionButton = actionButton
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        self.do {
            $0.backgroundColor = .grayscale90080
            $0.layer.cornerRadius = 12
        }
        titleLabel.do {
            $0.font = FontManager.sub3M18.font
            $0.textColor = .grayscale50
            $0.textAlignment = .center
        }
        descriptionLabel.do {
            $0.font = FontManager.body3R16.font
            $0.textColor = .grayscale400
            $0.textAlignment = .center
        }
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 16
        }
        setBlurEffect()
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            buttonStackView
        )
        if descriptionLabel.text != nil {
            addSubview(descriptionLabel)
        }
        if let dismissButton = dismissButton {
            buttonStackView.addArrangedSubviews(dismissButton, actionButton)
        }
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        if descriptionLabel.text != nil {
            descriptionLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
                $0.centerX.equalToSuperview()
            }
            buttonStackView.snp.makeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(16.adjustedH)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(24.adjustedH)
            }
        } else {
            buttonStackView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(24.adjustedH)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(24.adjustedH)
            }
        }
        
        if let cancelButton = dismissButton {
            cancelButton.snp.makeConstraints {
                $0.width.equalTo(108.adjustedW)
                $0.height.equalTo(53.adjustedH)
            }
        }
        actionButton.snp.makeConstraints {
            $0.width.equalTo(108.adjustedW)
            $0.height.equalTo(53.adjustedH)
        }
    }
}
