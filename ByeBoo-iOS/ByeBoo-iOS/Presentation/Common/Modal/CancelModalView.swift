//
//  CancelModalView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/23/25.
//

import UIKit

final class CancelModalView: BaseView, ModalProtocol {
    
    private let titleLabel = UILabel()
    private let secondDescriptionLabel = UILabel()
    private let buttonStackView = UIStackView()
    let dismissButton: ByeBooButton? = ByeBooButton(titleText: "취소", type: .outline)
    let actionButton = ByeBooButton(titleText: "탈퇴하기", type: .enabled)
    
    override func setUI() {
        addSubviews(
            titleLabel,
            secondDescriptionLabel,
            buttonStackView
        )
        if let dismissButton = dismissButton {
            buttonStackView.addArrangedSubviews(dismissButton, actionButton)
        }
    }
    
    override func setStyle() {
        self.do {
            $0.backgroundColor = .grayscale90080
            $0.layer.cornerRadius = 12
        }
        titleLabel.do {
            $0.text = "정말 탈퇴하시겠어요?"
            $0.font = FontManager.sub3M18.font
            $0.textColor = .grayscale50
            $0.textAlignment = .center
        }
        
        secondDescriptionLabel.do {
            $0.text = "탈퇴 시 모든 데이터가 삭제됩니다."
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
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.adjustedH)
            $0.centerX.equalToSuperview()
        }
        secondDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
            $0.centerX.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(secondDescriptionLabel.snp.bottom).offset(16.adjustedH)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24.adjustedH)
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
