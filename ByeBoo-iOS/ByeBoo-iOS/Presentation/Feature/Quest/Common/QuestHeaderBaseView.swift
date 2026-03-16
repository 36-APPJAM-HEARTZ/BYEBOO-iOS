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
        
        titleLabel.applyByeBooFont (
            style: .head2M22,
            color: .grayscale50,
            textAlignment: .left,
            numberOfLines: 0
        )
        subTitleLabel.applyByeBooFont (
            style: .body6R14,
            text: subtitleText,
            color: .grayscale400,
            textAlignment: .left
        )
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
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
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
