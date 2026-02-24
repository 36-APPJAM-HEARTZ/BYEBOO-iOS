//
//  CommonQuestHistoryView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import UIKit

final class CommonQuestHistoryView: BaseView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let commonQuestLabel = UILabel()
    private let dateLabel = UILabel()
    private let questionView = UIView()
    private let questionMarkLabel = UILabel()
    private let questionContentLabel = UILabel()
    private let answerView = UIView()
    private let profileIconImageView = UIImageView()
    private let userNicknameLabel = UILabel()
    private let answerContentLabel = UILabel()
    
    override func setStyle() {
        commonQuestLabel.applyByeBooFont(
            style: .body6R14,
            text: "공통퀘스트",
            color: .grayscale500
        )
        dateLabel.applyByeBooFont(
            style: .body6R14,
            color: .grayscale500
        )
        questionMarkLabel.applyByeBooFont(
            style: .head2M22,
            text: "Q.",
            color: .primary200
        )
        questionContentLabel.do {
            $0.applyByeBooFont(
                style: .head2M22,
                color: .grayscale50,
                numberOfLines: 0
            )
            $0.lineBreakStrategy = []
        }
        answerView.do {
            $0.layer.cornerRadius = 12
            $0.backgroundColor = .white5
        }
        userNicknameLabel.applyByeBooFont(
            style: .body6R14,
            color: .grayscale200
        )
        answerContentLabel.do {
            $0.applyByeBooFont(
                style: .body3R16,
                color: .grayscale100,
                numberOfLines: 0
            )
        }
    }
    
    override func setUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            commonQuestLabel,
            dateLabel,
            questionView,
            answerView
        )
        questionView.addSubviews(
            questionMarkLabel,
            questionContentLabel
        )
        answerView.addSubviews(
            profileIconImageView,
            userNicknameLabel,
            answerContentLabel
        )
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(24.adjustedH)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        commonQuestLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(21.adjustedH)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(commonQuestLabel.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(21.adjustedH)
        }
        questionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        questionMarkLabel.snp.makeConstraints {
            $0.top.equalTo(questionContentLabel.snp.top)
            $0.leading.equalToSuperview()
            $0.width.equalTo(21.adjustedW)
        }
        questionContentLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(questionMarkLabel.snp.trailing).offset(4.adjustedW)
            $0.trailing.equalToSuperview()
        }
        answerView.snp.makeConstraints {
            $0.top.equalTo(questionView.snp.bottom).offset(30.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24.adjustedH)
        }
        profileIconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.size.equalTo(20.adjustedW)
        }
        userNicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileIconImageView.snp.trailing).offset(4.adjustedW)
            $0.centerY.equalTo(profileIconImageView)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
        }
        answerContentLabel.snp.makeConstraints {
            $0.top.equalTo(profileIconImageView.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(16.adjustedH)
        }
    }
}

extension CommonQuestHistoryView {
    
    func configure(
        question: String,
        writtenAt: Date,
        profileIcon: UIImage?,
        nickname: String,
        content: String
    ) {
        questionContentLabel.text = question
        dateLabel.text = DateFormatter.standard.string(from: writtenAt)
        profileIconImageView.image = profileIcon
        userNicknameLabel.text = nickname
        answerContentLabel.text = content
    }
}
