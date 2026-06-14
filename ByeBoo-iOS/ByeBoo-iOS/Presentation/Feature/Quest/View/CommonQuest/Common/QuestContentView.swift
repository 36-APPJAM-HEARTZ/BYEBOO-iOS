//
//  QuestContentView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 4/29/26.
//

import UIKit

protocol CommonQuestLikeProtocol: AnyObject {
    func likeButtonDidTap()
}

final class QuestContentView: BaseView {
    
    private let answerContentTextView = UITextView()
    private let writtenDateLabel = UILabel()
    
    private let likeCommentStackView = UIStackView()
    private let likeContainerView = UIStackView()
    private(set) var likeButton = UIButton()
    private let likeCountLabel = UILabel()
    private let commentContainerView = UIStackView()
    private let commentIcon = UIImageView()
    private let commentCountLabel = UILabel()
    
    weak var delegate: CommonQuestLikeProtocol?
    
    private var answerID: Int = 0
    private var likeCounts: Int = 0
    
    override func setUI() {
        self.addSubviews(
            answerContentTextView,
            writtenDateLabel,
            likeCommentStackView
        )
        likeCommentStackView.addArrangedSubviews(likeContainerView, commentContainerView)
        likeContainerView.addArrangedSubviews(likeButton, likeCountLabel)
        commentContainerView.addArrangedSubviews(commentIcon, commentCountLabel)
    }
    
    override func setStyle() {
        answerContentTextView.do {
            $0.applyByeBooFont(style: .body3R16, color: .grayscale100)
            $0.isScrollEnabled = false
            $0.isEditable = false
            $0.isSelectable = false
            $0.isUserInteractionEnabled = false
            $0.backgroundColor = .clear
            $0.textContainer.lineBreakMode = .byTruncatingTail
        }
        writtenDateLabel.do {
            $0.applyByeBooFont(style: .cap2R12, color: .grayscale400)
            $0.isHidden = true
        }
        likeCommentStackView.do {
            $0.axis = .horizontal
            $0.spacing = 16.adjustedW
        }
        [likeContainerView, commentContainerView].forEach {
            $0.do {
                $0.axis = .horizontal
                $0.spacing = 4.adjustedW
            }
        }
        likeButton.do {
            $0.setImage(.heartOff, for: .normal)
            $0.setImage(.heartOn, for: .selected)
            $0.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
        }
        commentIcon.do {
            $0.image = .comment
        }
        [likeCountLabel, commentCountLabel].forEach {
            $0.do {
                $0.text = "0"
                $0.applyByeBooFont(style: .cap2R12, color: .grayscale100)
            }
        }
    }
    
    override func setLayout() {
        answerContentTextView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        writtenDateLabel.snp.makeConstraints {
            $0.top.equalTo(answerContentTextView.snp.bottom).offset(20.adjustedH)
            $0.leading.equalToSuperview()
            $0.height.equalTo(16.adjustedH)
        }
        likeCommentStackView.snp.makeConstraints {
            $0.top.equalTo(answerContentTextView.snp.bottom).offset(20)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        [likeButton, commentIcon].forEach {
            $0.snp.makeConstraints {
                $0.size.equalTo(20)
            }
        }
    }
    
    func configure(
        answerID: Int,
        content: String,
        writtenAt: String? = nil,
        isLiked: Bool,
        likeCount: Int,
        commentCount: Int,
        showAllText: Bool
    ) {
        self.answerID = answerID
        self.likeCounts = likeCount
        answerContentTextView.do {
            $0.textContainer.maximumNumberOfLines = showAllText ? 0 : 2
            $0.applyTextViewStyle(style: .body3R16, text: content, color: .grayscale100)
        }
        if let writtenAt {
            writtenDateLabel.isHidden = false
            writtenDateLabel.text = writtenAt
        }
        likeButton.isSelected = isLiked
        likeCountLabel.text = String(likeCount)
        commentCountLabel.text = String(commentCount)
    }
    
    func updateUI(likeCount: Int, isLiked: Bool) {
        likeCountLabel.text = String(likeCount)
        likeButton.isSelected = isLiked
    }
    
    @objc
    private func likeButtonDidTap() {
        delegate?.likeButtonDidTap(answerID: self.answerID)
    }
}
