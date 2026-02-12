//
//  TopTabBarItemView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/12/26.
//

import UIKit

final class TopTabBarItemView: BaseView {
    
    private let journeyStackView = UIStackView()
    private let journeyImageView = UIImageView()
    private let journeyNameLabel = UILabel()
    private let underlineLabel = UILabel()
    
    init(item: any TabItem) {
        journeyImageView.image = item.image
        journeyNameLabel.text = item.title
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        journeyStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .center
        }
        journeyNameLabel.do {
            $0.textColor = .grayscale100
            $0.font = FontManager.body2M16.font
            $0.textAlignment = .center
        }
        underlineLabel.do {
            $0.backgroundColor = .grayscale300
            $0.layer.borderWidth = 1
        }
    }
    
    override func setUI() {
        addSubviews(
            journeyStackView,
            underlineLabel
        )
        journeyStackView.addArrangedSubviews(
            journeyImageView,
            journeyNameLabel
        )
    }
    
    override func setLayout() {
        journeyStackView.snp.makeConstraints {
            $0.width.equalTo(108.adjustedW)
            $0.height.equalTo(24.adjustedH)
        }
        journeyImageView.snp.makeConstraints {
            $0.size.equalTo(24.adjustedW)
        }
        journeyNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(59.adjustedW)
            $0.height.equalTo(21.adjustedH)
        }
        underlineLabel.snp.makeConstraints {
            $0.top.equalTo(journeyStackView.snp.bottom).offset(4.adjustedH)
            $0.width.equalTo(108.adjustedW)
            $0.height.equalTo(1.adjustedH)
        }
    }
}
