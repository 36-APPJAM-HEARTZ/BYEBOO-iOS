//
//  ThinkView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

final class ThinkView: BaseView {

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionView: TextBoxView
    
    private let descriptionText: String
    
    init(descriptionText: String) {
        self.descriptionText = descriptionText
        descriptionView = TextBoxView(title: descriptionText)
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        iconImageView.do {
            $0.image = .think
        }
        titleLabel.do {
            $0.text = "이렇게 생각했어요"
            $0.font = FontManager.body2M16.font
            $0.textColor = .grayscale200
        }
    }
    
    override func setUI() {
        addSubviews(
            iconImageView,
            titleLabel,
            descriptionView
        )
    }
    
    override func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.5.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.5.adjustedH)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8.adjustedW)
        }
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(24.5.adjustedH)
        }
    }
}
