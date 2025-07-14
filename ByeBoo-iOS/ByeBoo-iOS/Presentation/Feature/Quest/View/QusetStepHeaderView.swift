//
//  QusetStepHeaderView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import UIKit

import SnapKit
import Then

final class QuestStepHeaderView: UICollectionReusableView {
    
    private let sectionDividerView = SectionDividerView()
    private let stepLabel = UILabel()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        stepLabel.do {
            $0.textColor = .secondary300
            $0.font = FontManager.cap1M12.font
        }
        titleLabel.do {
            $0.textColor = .grayscale50
            $0.font = FontManager.body2M16.font
        }
    }
    
    private func setUI() {
        addSubviews(
            sectionDividerView,
            stepLabel,
            titleLabel
        )
    }
    
    private func setLayout() {
        sectionDividerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.adjustedH)
        }
        stepLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(sectionDividerView.snp.bottom).offset(18.adjustedH)
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(sectionDividerView.snp.bottom).offset(18.adjustedH)
            $0.leading.equalTo(stepLabel.snp.trailing).offset(8.adjustedW)
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    func setStep(stepNumber: Int, step: String) {
        self.stepLabel.text = "STEP \(stepNumber)"
        self.titleLabel.text = step
    }
}
