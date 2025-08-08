//
//  OnboardingHeaderView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

import UIKit

final class OnboardingHeaderView: BaseView {

    private let stepLabel = UILabel()
    let skipStackView = UIStackView()
    private let skipLabel = UILabel()
    private let arrowImageView = UIImageView()
    
    var step: OnboardingStep = .first {
        didSet {
            changeStep()
        }
    }
    
    override func setStyle() {
        stepLabel.do {
            $0.text = "\(step.rawValue)/3"
            $0.font = FontManager.body6R14.font
            $0.textColor = .primary300
        }
        skipStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
            $0.isHidden = step.rawValue == 3 ? true : false
        }
        skipLabel.do {
            $0.text = "SKIP"
            $0.underLine(text: $0.text ?? "")
            $0.font = FontManager.body6R14.font
            $0.textColor = .primary300
        }
        
        arrowImageView.do {
            $0.image = .right.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .primary300
        }
    }
    
    override func setUI() {
        addSubviews(
            stepLabel,
            skipStackView
        )
        skipStackView.addArrangedSubviews(
            skipLabel,
            arrowImageView
        )
    }
    
    override func setLayout() {
        stepLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(72.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(16.adjustedH)
        }
        skipStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(72.adjustedH)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(18.adjustedH)
        }
        arrowImageView.snp.makeConstraints {
            $0.size.equalTo(12.adjustedW)
        }
    }
}

extension OnboardingHeaderView {
    private func changeStep() {
        self.stepLabel.text = "\(step.rawValue)/3"
        self.skipStackView.isHidden = step.rawValue == 3 ? true : false
    }
}
