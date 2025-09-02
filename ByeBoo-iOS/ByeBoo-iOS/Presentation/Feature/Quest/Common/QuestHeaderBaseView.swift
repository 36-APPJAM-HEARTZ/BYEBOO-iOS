//
//  QuestHeaderBaseView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 9/1/25.
//

import UIKit

import SnapKit
import Then

class QuestHeaderBaseView: BaseView {
    
    var periodTag = ByeBooFilledTag(tagType: .smallGray, text: "")
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    
    var subtitleText: String { "" }
    func configure(nickname: String, journey: String, period: String) {}
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        titleLabel.do {
            $0.font = FontManager.head1M24.font
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.textColor = .grayscale50
        }
        subTitleLabel.do {
            $0.text = subtitleText
            $0.textColor = .grayscale400
            $0.textAlignment = .left
            $0.font = FontManager.body6R14.font
        }
    }
    
    override func setUI() {
        addSubviews(
            periodTag,
            titleLabel,
            subTitleLabel
        )
    }
    
    override func setLayout() {
        periodTag.snp.makeConstraints {
            $0.top.equalToSuperview().inset(72.adjustedH)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).inset(24.adjustedW)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(periodTag.snp.bottom).offset(8.adjustedH)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).inset(24.adjustedW)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.adjustedH)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(19.adjustedH)
        }
    }
}
