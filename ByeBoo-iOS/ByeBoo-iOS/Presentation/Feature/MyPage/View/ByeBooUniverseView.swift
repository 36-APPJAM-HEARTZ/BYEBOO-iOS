//
//  ByeBooWorldView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/21/25.
//

import UIKit

final class ByeBooUniverseView: BaseView {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private(set) var textBoxView = OneLineTextBoxView(title: "Bye Boo 세계관 보러 가기", isHighlighted: true)
    
    override func setStyle() {
        iconImageView.do {
            $0.image = .change
        }
        titleLabel.do {
            $0.text = "보리가 궁금하다면?"
            $0.font = FontManager.body1Sb16.font
            $0.textColor = .grayscale300
        }
    }
    
    override func setUI() {
        addSubviews(
            iconImageView,
            titleLabel,
            textBoxView
        )
    }
    
    override func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.5.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8.adjustedW)
            $0.centerY.equalTo(iconImageView.snp.centerY)
        }
        
        textBoxView.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(12.adjustedH)
            $0.bottom.equalToSuperview().inset(24.5.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
    }
}
