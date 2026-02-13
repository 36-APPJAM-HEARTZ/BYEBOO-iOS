//
//  ByeBooQuitModal.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/6/25.
//

import UIKit

import SnapKit
import Then

final class QuitModalView: BaseView, ModalProtocol {
    var modalType: ConfirmModalType? = nil
    private let titleLabel = UILabel()
    private let secondDescriptionLabel = UILabel()
    private let buttonStackView = UIStackView()
    let dismissButton: ByeBooButton? = ByeBooButton(titleText: "머무르기", type: .enabled)
    let actionButton = ByeBooButton(titleText: "나가기", type: .outline)
    
    override func setUI() {
        backgroundColor = .grayscale900
        layer.cornerRadius = 12
        
        addSubviews(
            titleLabel,
            secondDescriptionLabel,
            buttonStackView
        )
        
        if let dismissButton = dismissButton {
            buttonStackView.addArrangedSubviews(actionButton, dismissButton)
        }
    }
    
    override func setStyle() {
        titleLabel.applyByeBooFont(
            style: FontManager.sub3M18,
            text: "작성을 중단하시겠어요?",
            color: .grayscale50,
            textAlignment: .center
        )
        
        secondDescriptionLabel.applyByeBooFont(
            style: FontManager.body3R16,
            text: "작성하시던 내용은 저장되지 않아요.",
            color: .grayscale400,
            textAlignment: .center
        )
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 16
        }
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
                $0.width.equalTo(107.adjustedW)
                $0.height.equalTo(53.adjustedH)
            }
        }
        
        actionButton.snp.makeConstraints {
            $0.width.equalTo(107.adjustedW)
            $0.height.equalTo(53.adjustedH)
        }
    }
}
