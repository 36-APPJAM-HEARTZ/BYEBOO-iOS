//
//  CommonQuestContentCell.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/21/26.
//

import UIKit

final class CommonQuestContentCell: UITableViewCell {
    
    private let questionView = UIView()
    private let questionMarkLabel = UILabel()
    private let questionContentLabel = UILabel()
    private let guideTimeLabel = UILabel()
    private(set) var moveWriteAnswerButton = UIButton()
    private let answersCountLabel = UILabel()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.do {
            $0.backgroundColor = .grayscale900
            $0.selectionStyle = .none
        }
        questionMarkLabel.applyByeBooFont(
            style: .body1Sb16,
            text: "Q.",
            color: .primary200
        )
        questionContentLabel.do {
            $0.applyByeBooFont(
                style: .sub3M18,
                color: .grayscale50,
                numberOfLines: 0
            )
            $0.lineBreakStrategy = []
        }
        guideTimeLabel.applyByeBooFont(
            style: .cap2R12,
            text: "23:59까지 답변 가능해요",
            color: .grayscale400,
            textAlignment: .left
        )
        moveWriteAnswerButton.do {
            $0.applyByeBooFont(
                style: .body2M16,
                text: "답변 작성하기",
                color: .primary500
            )
            $0.layer.cornerRadius = 12
            $0.backgroundColor = .primary100
        }
        answersCountLabel.applyByeBooFont(
            style: .cap2R12,
            color: .grayscale400,
            textAlignment: .left
        )
    }
    
    private func setUI() {
        contentView.addSubviews(
            questionView,
            guideTimeLabel,
            moveWriteAnswerButton,
            answersCountLabel
        )
        questionView.addSubviews(
            questionMarkLabel,
            questionContentLabel
        )
    }
    
    private func setLayout() {
        questionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        questionMarkLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(17.adjustedW)
        }
        questionContentLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(questionMarkLabel.snp.trailing).offset(4.adjustedW)
            $0.trailing.equalToSuperview()
        }
        guideTimeLabel.snp.makeConstraints {
            $0.top.equalTo(questionView.snp.bottom).offset(12.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        moveWriteAnswerButton.snp.makeConstraints {
            $0.top.equalTo(guideTimeLabel.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(53.adjustedH)
        }
        answersCountLabel.snp.makeConstraints {
            $0.top.equalTo(moveWriteAnswerButton.snp.bottom).offset(24.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
    }
}

extension CommonQuestContentCell {
    
    func bind(question: String, answersCount: Int) {
        questionContentLabel.text = question
        guideTimeLabel.text = "\(answersCount)개의 답변"
    }
}
