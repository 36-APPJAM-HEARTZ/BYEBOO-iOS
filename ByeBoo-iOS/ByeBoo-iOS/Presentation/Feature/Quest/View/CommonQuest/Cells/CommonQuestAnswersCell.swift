//
//  CommonQuestAnswersCell.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/17/26.
//

import UIKit

final class CommonQuestAnswersCell: UITableViewCell {
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd."
        return formatter
    }()
    
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
            $0.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        }
        userNicknameLabel.do {
            $0.textColor = .grayscale200
            $0.font = FontManager.body6R14.font
        }
        answerContentLabel.do {
            $0.textColor = .grayscale100
            $0.font = FontManager.body3R16.font
            $0.numberOfLines = 0
        }
        writtenDateLabel.do {
            $0.textColor = .grayscale400
            $0.font = FontManager.body6R14.font  // TO-DO : 폰트 NotoSans로 수정하기
        }
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

extension CommonQuestAnswersCell {
    
    func bind(
        profileIcon: UIImage?,
        answer: CommonQuestAnswerEntity
    ) {
        if let profileIcon {
            userIconView.image = profileIcon
        } else {
            userIconView.do {
                $0.backgroundColor = .grayscale600
                $0.layer.cornerRadius = 10
            }
        }
        userNicknameLabel.text = answer.writer
        answerContentLabel.text = answer.content
        writtenDateLabel.text = dateFormatter.string(from: answer.writtenAt)
    }
}
