//
//  CommonQuestHeaderView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/17/26.
//

import UIKit

final class CommonQuestHeaderView: BaseView {
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private(set) var historyButton = UIButton()
    private let underline = UILabel()
    
    override func setStyle() {
        titleLabel.do {
            $0.text = "함께 이별을 극복하는 공간이에요"
            $0.textColor = .grayscale50
            $0.textAlignment = .left
            $0.font = FontManager.head2M22.font
            $0.numberOfLines = 1
        }
        subtitleLabel.do {
            $0.text = "공통 퀘스트를 통해 나의 이야기를 솔직히 털어놓고,\n타인의 답변도 확인해 보세요"
            $0.textColor = .grayscale300
            $0.textAlignment = .left
            $0.font = FontManager.body6R14.font
            $0.numberOfLines = 2
        }
        historyButton.do {
            $0.setTitle("나의 답변 모아보기", for: .normal)
            $0.setTitleColor(.primary200, for: .normal)
            $0.titleLabel?.font = FontManager.cap1M12.font
            $0.layer.cornerRadius = 12
            $0.layer.borderColor = UIColor.grayscale800.cgColor
            $0.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        }
        underline.do {
            $0.backgroundColor = .grayscale800
            $0.layer.borderColor = UIColor.grayscale800.cgColor
            $0.layer.borderWidth = 1
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            subtitleLabel,
            historyButton,
            underline
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        historyButton.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(16.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.width.equalTo(123.adjustedW)
            $0.height.equalTo(24.adjustedH)
        }
        underline.snp.makeConstraints {
            $0.top.equalTo(historyButton.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(1.adjustedH)
        }
    }
}
