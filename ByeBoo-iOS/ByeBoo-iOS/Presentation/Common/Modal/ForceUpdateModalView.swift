//
//  ForceUpdateModalView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/4/26.
//

import UIKit

import SnapKit
import Then

final class ForceUpdateModalView: BaseView, ModalProtocol {
    let actionButton: ByeBooButton = ByeBooButton(titleText: "업데이트 하러 가기", type: .enabled)
    let dismissButton: ByeBooButton? = nil
    let modalType: ConfirmModalType?  = nil
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func setUI() {
        addSubviews(titleLabel, descriptionLabel, actionButton)
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        layer.cornerRadius = 12
        
        titleLabel.applyByeBooFont(
            style: .sub3M18,
            text: "새로운 업데이트가 있어요",
            color: .grayscale50
        )
        
        descriptionLabel.applyByeBooFont(
            style: .body3R16,
            text: "더 나은 바이부를 만나보세요",
            color: .grayscale400
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.adjustedH)
            $0.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
            $0.centerX.equalToSuperview()
        }
        actionButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16.adjustedH)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(24.adjustedH)
            $0.height.equalTo(53.adjustedH)
        }
    }
}

