//
//  QuestContentView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 4/29/26.
//

import UIKit

protocol CommonQuestLikeCommentProtocol: AnyObject {
    func likeButtonDidTap()
}

final class QuestContentView: BaseView {
    
    private let answerContentLabel = UILabel()
    private let writtenDateLabel = UILabel()
    
    private let likeCommentStackView = UIStackView()
    private let likeContainerView = UIStackView()
    private(set) var likeButton = UIButton()
    private let likeCountLabel = UILabel()
    private let commentContainerView = UIStackView()
    private let commentIcon = UIImageView()
    private let commentCountLabel = UILabel()
    
    weak var delegate: CommonQuestLikeCommentProtocol?
    
    private var likeCounts: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        self.addSubviews(
            answerContentLabel,
            writtenDateLabel,
            likeCommentStackView
        )
        likeCommentStackView.addArrangedSubviews(likeContainerView, commentContainerView)
        likeContainerView.addArrangedSubviews(likeButton, likeCountLabel)
        commentContainerView.addArrangedSubviews(commentIcon, commentCountLabel)
    }
    
    override func setStyle() {
        answerContentLabel.applyByeBooFont(
            style: .body3R16,
            color: .grayscale100,
            numberOfLines: 2
        )
        writtenDateLabel.applyByeBooFont(
            style: .cap2R12,
            color: .grayscale400
        )
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
        answerContentLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47.adjustedH)
        }
        writtenDateLabel.snp.makeConstraints {
            $0.top.equalTo(answerContentLabel.snp.bottom).offset(20.adjustedH)
            $0.leading.equalToSuperview()
            $0.height.equalTo(16.adjustedH)
        }
        likeCommentStackView.snp.makeConstraints {
            $0.centerY.equalTo(writtenDateLabel)
            $0.trailing.equalToSuperview()
        }
        [likeButton, commentIcon].forEach {
            $0.snp.makeConstraints {
                $0.size.equalTo(20)
            }
        }
    }
    
    func configure(
        content: String,
        writtenAt: String,
        isLiked: Bool,
        likeCount: Int,
        commentCount: Int
    ) {
        self.likeCounts = likeCount
        answerContentLabel.text = content
        writtenDateLabel.text = writtenAt
        likeButton.isSelected = isLiked
        likeCountLabel.text = String(likeCount)
        commentCountLabel.text = String(commentCount)
    }
    
    @objc
    private func likeButtonDidTap() {
        likeButton.isSelected.toggle()
        likeCounts += likeButton.isSelected ? 1 : -1
        likeCountLabel.text = String(likeCounts)
        delegate?.likeButtonDidTap()
    }
}
