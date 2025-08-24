//
//  InquireView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/21/25.
//

import UIKit

final class MyPageFeatureView: BaseView {
    
    private let titleLabel = UILabel()
    private let featureStackView = UIStackView()
    private(set) var featureButtons: [UIButton] = []
    
    init(title: String, features: [MyPageDetailFeatureType]) {
        titleLabel.text = title
        super.init(frame: .zero)

        setFeatureButtons(features: features)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setFeatureButtons(features: [MyPageDetailFeatureType]) {
        features.forEach { [weak self] feature in
            let featureButton = UIButton()
            featureButton.do {
                $0.setTitle(feature.rawValue, for: .normal)
                $0.titleLabel?.font = FontManager.body3R16.font
                $0.setTitleColor(.grayscale50, for: .normal)
                $0.backgroundColor = .clear
            }
            self?.featureButtons.append(featureButton)
            self?.featureStackView.addArrangedSubview(featureButton)
        }
    }
    
    override func setStyle() {
        titleLabel.do {
            $0.font = FontManager.body1Sb16.font
            $0.textColor = .grayscale400
            $0.textAlignment = .left
        }
        featureStackView.do {
            $0.axis = .vertical
            $0.spacing = 16
            $0.alignment = .leading
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            featureStackView
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        featureStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(24.5.adjustedH)
        }
    }
}
