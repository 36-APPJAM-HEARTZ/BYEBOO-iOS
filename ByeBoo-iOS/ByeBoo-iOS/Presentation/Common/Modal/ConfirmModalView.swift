//
//  ConfirmModalView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/24/25.
//

import UIKit

final class ConfirmModalView: BaseView, ModalProtocol {
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let buttonStackView = UIStackView()
    let dismissButton: ByeBooButton?
    let actionButton: ByeBooButton
    
    init(
        title: String,
        description: String? = nil,
        dismissButton: ByeBooButton?,
        actionButton: ByeBooButton
    ) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
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
