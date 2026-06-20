//
//  CommonQuestAnswerCell.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/17/26.
//

import UIKit

import SnapKit

final class CommonQuestAnswerCell: UITableViewCell {
        
    private var answerID: Int?
    
    private let containerView = UIView()
    private let userIconView = UIImageView()
    private let userNicknameLabel = UILabel()
    private(set) var questContentView = QuestContentView()
    
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
        userNicknameLabel.applyByeBooFont(
            style: .body6R14,
            color: .grayscale200
        )
    }
    
    private func setUI() {
        contentView.addSubview(containerView)
        containerView.addSubviews(
            userIconView,
            userNicknameLabel,
            questContentView
        )
    }
    
    private func setLayout() {
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview()
        }
        userIconView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.size.equalTo(20.adjustedW)
        }
        userNicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalTo(userIconView.snp.trailing).offset(4.adjustedW)
            $0.centerY.equalTo(userIconView.snp.centerY)
        }
        questContentView.snp.makeConstraints {
            $0.top.equalTo(userNicknameLabel.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(16.adjustedH)
        }
    }
}

extension CommonQuestAnswerCell {
    
    func bind(
        profileIcon: UIImage?,
        answer: CommonQuestAnswerEntity,
        writtenAt: String
    ) {
        if let profileIcon {
            userIconView.image = profileIcon
        }
        userNicknameLabel.text = answer.writer
        answerID = answer.answerID
        questContentView.configure(
            content: answer.content,
            writtenAt: writtenAt,
            isLiked: answer.isLiked,
            likeCount: answer.likeCount,
            commentCount: answer.commentCount,
            showAllText: false
        )
    }
    
    func getAnswewrID() -> Int? {
        return answerID
    }
}
