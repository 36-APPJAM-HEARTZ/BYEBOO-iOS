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
    private var journeyType: JourneyType = .face
    
    private var periodTag = ByeBooFilledTag(tagType: .word3Gray, text: "")
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    override func setStyle() {
        backgroundColor = .black50
        titleLabel.do {
            titleLabel.attributedText = "\(nickname)님, 지금\n\(journeyType.description)을 진행 중이에요.".makeTitle(
                rangedText: "\(journeyType.description)"
            )
            $0.font = FontManager.head1Sb24.font
            $0.numberOfLines = 2
            $0.textAlignment = .left
        }
        subTitleLabel.do {
            $0.text = "오늘도 한 걸음 나아가볼까요?"
            $0.textColor = .grayscale400
            $0.textAlignment = .left
            $0.font = FontManager.body5R14.font
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
        }
    }
    
    func updateHeader(nickname: String, journeyType: JourneyType) {
        self.nickname = nickname
        self.journeyType = journeyType
        titleLabel.attributedText = "\(nickname)님, 지금\n\(journeyType.description)을 진행 중이에요.".makeTitle(
            rangedText: journeyType.description
        )
    }
    
    func updatePeriod(_ period: String) {
        periodTag.updateText("\(period)일째")
    }
}
