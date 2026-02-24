//
//  CommonQuestMyAnswerCell.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import UIKit

final class CommonQuestMyAnswerCell: UITableViewCell {
    
    private let containerView = UIView()
    private let questionView = UIView()
    private let questionMarkLabel = UILabel()
    private let questionContentLabel = UILabel()
    private let answerContentLabel = UILabel()
    private let writtenDateLabel = UILabel()
    
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
            $0.backgroundColor = .clear
            $0.selectionStyle = .none
        }
        containerView.do {
            $0.layer.cornerRadius = 12
            $0.backgroundColor = .white5
        }
        questionMarkLabel.applyByeBooFont(
            style: .sub2Sb18,
            text: "Q.",
            color: .primary200
        )
        questionContentLabel.do {
            $0.applyByeBooFont(
                style: .sub3M18,
                color: .grayscale100,
                numberOfLines: 0
            )
            $0.lineBreakStrategy = []
        }
        answerContentLabel.applyByeBooFont(
            style: .body3R16,
            color: .grayscale100,
            numberOfLines: 2
        )
        writtenDateLabel.applyByeBooFont(
            style: .cap2R12,
            color: .grayscale400
        )
    }
    
    private func setUI() {
        contentView.addSubview(containerView)
        containerView.addSubviews(
            questionView,
            answerContentLabel,
            writtenDateLabel
        )
        questionView.addSubviews(
            questionMarkLabel,
            questionContentLabel
        )
    }
    
    private func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        questionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        questionMarkLabel.snp.makeConstraints {
            $0.top.equalTo(questionContentLabel.snp.top)
            $0.leading.equalToSuperview()
            $0.width.equalTo(17.adjustedW)
        }
        questionContentLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(questionMarkLabel.snp.trailing).offset(4.adjustedW)
            $0.trailing.equalToSuperview()
        }
        answerContentLabel.snp.makeConstraints {
            $0.top.equalTo(questionView.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(47.adjustedH)
        }
        writtenDateLabel.snp.makeConstraints {
            $0.top.equalTo(answerContentLabel.snp.bottom).offset(20.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(16.adjustedH)
            $0.height.equalTo(16.adjustedH)
        }
    }
}

extension CommonQuestMyAnswerCell {
    
    func bind(
        question: String,
        content: String,
        writtenAt: Date
    ) {
        questionContentLabel.text = question
        answerContentLabel.text = content
        writtenDateLabel.text = DateFormatter.standard.string(from: writtenAt)
    }
}
