//
//  QuestCheckHeaderView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import UIKit

import SnapKit
import Then

final class QuestCheckHeaderView: BaseView {
    
    private var nickname: String = ""
    private var journey: String = ""
    
    private var periodTag = ByeBooFilledTag(tagType: .smallGray, text: "")
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        titleLabel.do {
            $0.font = FontManager.head1M24.font
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
        subTitleLabel.do {
            $0.text = "오늘도 한 걸음 나아가볼까요?"
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
    
    func updateHeader(nickname: String, journey: String) {
        self.nickname = nickname
        self.journey = journey
        titleLabel.attributedText = "\(nickname)님, 지금\n\(journey) 여정을 진행 중이에요".makeTitle(
            rangedText: "\(journey) 여정"
        )
    }
    
    func updatePeriod(_ period: Int) {
        periodTag.updateText("\(period)일째")
    }
}
