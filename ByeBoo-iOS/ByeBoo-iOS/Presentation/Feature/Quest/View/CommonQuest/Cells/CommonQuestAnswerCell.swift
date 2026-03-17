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
    private var containerBottomConstraint: Constraint?
    
    private let containerView = UIView()
    private let userIconView = UIImageView()
    private let userNicknameLabel = UILabel()
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
        userNicknameLabel.applyByeBooFont(
            style: .body6R14,
            color: .grayscale200
        )
        answerContentLabel.applyByeBooFont(
            style: .body3R16,
            color: .grayscale100,
            numberOfLines: 0
        )
        writtenDateLabel.applyByeBooFont(
            style: .body6R14,
            color: .grayscale400
        )
    }
    
    private func setUI() {
        addSubview(containerView)
        containerView.addSubviews(
            userIconView,
            userNicknameLabel,
            answerContentLabel,
            writtenDateLabel
        )
    }
    
    private func setLayout() {
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            containerBottomConstraint = $0.bottom.equalToSuperview().constraint
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
        answerContentLabel.snp.makeConstraints {
            $0.top.equalTo(userIconView.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(47.adjustedH)
        }
        writtenDateLabel.snp.makeConstraints {
            $0.top.equalTo(answerContentLabel.snp.bottom).offset(20.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(16.adjustedH)
        }
    }
}

extension CommonQuestAnswerCell {
    
    func bind(
        profileIcon: UIImage?,
        answer: CommonQuestAnswerEntity,
        writtenAt: String,
        isLast: Bool
    ) {
        if let profileIcon {
            userIconView.image = profileIcon
        }
        userNicknameLabel.text = answer.writer
        answerContentLabel.text = answer.content
        writtenDateLabel.text = writtenAt
        
        answerID = answer.answerID
        
        let inset = isLast ? 24.adjustedH : 0
        containerBottomConstraint?.update(inset: inset)
    }
    
    func getAnswewrID() -> Int? {
        return answerID
    }
}
