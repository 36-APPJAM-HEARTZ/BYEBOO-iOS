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
    private(set) var noticeSwitch = UISwitch()
    
    init(title: String, features: [MyPageDetailFeatureType]) {
        titleLabel.text = title
        super.init(frame: .zero)
        
        setFeatures(features)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        titleLabel.do {
            $0.font = FontManager.body1Sb16.font
            $0.textColor = .grayscale400
            $0.textAlignment = .left
        }
        featureStackView.do {
            $0.axis = .vertical
            $0.spacing = 14
        }
        noticeSwitch.do {
            $0.onTintColor = .primary300
            $0.tintColor = .grayscale600
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
            $0.top.equalToSuperview().offset(24.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        featureStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.bottom.equalToSuperview().inset(24.adjustedW)
        }
    }
    
    private func setFeatures(_ features: [MyPageDetailFeatureType]) {
        features
            .map {
                let featureButton = self.createFeatureButton(feature: $0.rawValue)
                self.featureButtons.append(featureButton)
                                
                if $0 == .questOpenNotice {
                    featureStackView.alignment = .fill
                    return createNoticeView(button: featureButton)
                }
                featureStackView.alignment = .leading
                return featureButton
            }
            .forEach {
                featureStackView.addArrangedSubview($0)
            }
    }
    
    private func createFeatureButton(feature: String) -> UIButton {
        let featureButton = UIButton()
        featureButton.do {
            $0.setTitle(feature, for: .normal)
            $0.titleLabel?.font = FontManager.body3R16.font
            $0.setTitleColor(.grayscale50, for: .normal)
            $0.backgroundColor = .clear
        }
        
        return featureButton
    }
    
    private func createNoticeView(button: UIButton) -> UIView {
        let noticeView = UIView()
        noticeView.addSubviews(button, noticeSwitch)
        makeNoticeViewConstraints(button: button)
        
        return noticeView
    }
    
    private func makeNoticeViewConstraints(button: UIButton) {
        button.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        noticeSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(48.adjustedW)
            $0.height.equalTo(28.adjustedH)
        }
    }
}
