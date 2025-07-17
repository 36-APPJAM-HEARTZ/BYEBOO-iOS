//
//  CongrateModalView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/5/25.
//

import UIKit

import SnapKit
import Then

final class CongrateModalView: BaseView, ModalProtocol {
    
    let actionButton: ByeBooButton = ByeBooButton(titleText: "바로가기", type: .enabled)
    let dismissButton: ByeBooButton? = nil
    
    private let descriptionLabel = UILabel()
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let secondDescriptionLabel = UILabel()
    
    override func setStyle() {
        backgroundColor = .grayscale90080
        layer.cornerRadius = 12
        
        descriptionLabel.do {
            $0.text = "축하드려요!"
            $0.textAlignment = .center
            $0.textColor = .grayscale400
            $0.font = FontManager.body2M16.font
        }
        titleLabel.do {
            $0.text = "감정 직면 여정을\n모두 마무리 했어요"
            $0.numberOfLines = 2
            $0.textAlignment = .center
            $0.textColor = .grayscale50
            $0.font = FontManager.sub2Sb18.font
        }
        imageView.do {
            $0.image = .clover
        }
        secondDescriptionLabel.do {
            $0.text = "보리가 하츠핑님께\n하고싶은 말이 있다고 해요."
            $0.numberOfLines = 2
            $0.textAlignment = .center
            $0.textColor = .grayscale400
            $0.font = FontManager.body2M16.font
        }
        
        setBlurEffect()
    }
    
    override func setUI() {
        addSubviews(
            descriptionLabel,
            titleLabel,
            imageView,
            secondDescriptionLabel,
            actionButton
        )
    }
    
    override func setLayout() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(160.adjustedW)
        }
        
        secondDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints {
            $0.top.equalTo(secondDescriptionLabel.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}
