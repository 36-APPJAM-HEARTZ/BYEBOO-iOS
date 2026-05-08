//
//  CommentCellTableViewCell.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/4/26.
//

import UIKit

protocol CommentProtocol: AnyObject {
    func moreLabelDidTap(commentID: Int)
}

final class CommentTableViewCell: UITableViewCell {
    
    weak var delegate: CommentProtocol?
    
    private var replyCommentArrow = UIImageView()
    private var replyCommentContainer = UIView()
    private let profileIcon = UIImageView(image: .relievedBadge)
    private let nicknameLabel = UILabel()
    private let dateLabel = UILabel()
    private let menuButton = UIImageView()
    private let commentTextView = UITextView()
    private var moreLabel = UILabel()
    private var replyCountContainer = UIStackView()
    private var replyCommentIcon = UIImageView()
    private var replyCountLabel = UILabel()
    
    private var replyCount: Int = 0
    private var commentID: Int = 0
    private var content: String = ""
    private var didSetReplyLayout = false
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        contentView.addSubviews(profileIcon, nicknameLabel, dateLabel, menuButton, commentTextView, moreLabel)
    }
    
    private func setStyle() {
        backgroundColor = .grayscale900
        selectionStyle = .none
        
        nicknameLabel.do {
            $0.applyByeBooFont(style: .body5M14, color: .grayscale200)
        }
        
        dateLabel.do {
            $0.applyByeBooFont(style: .cap2R12, color: .grayscale400)
        }
        
        menuButton.do {
            $0.image = .menu
        }
        
        commentTextView.do {
            $0.isEditable = false
            $0.isScrollEnabled = false
            $0.isUserInteractionEnabled = false
            $0.isSelectable = false
            $0.backgroundColor = .clear
            $0.textContainerInset = .zero
            $0.textContainer.lineBreakMode = .byTruncatingTail
            $0.textContainer.lineFragmentPadding = 0
            $0.applyByeBooFont(style: .body6R14, color: .grayscale100)
        }
        
        moreLabel.do {
            $0.applyByeBooFont(style: .body6R14, text: "더보기", color: .grayscale400)
            $0.backgroundColor = .grayscale900
            $0.isUserInteractionEnabled = true
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(moreLabelDidTap(_:)))
            $0.addGestureRecognizer(tapRecognizer)
        }
        
        replyCountContainer.do {
            $0.axis = .horizontal
            $0.spacing = 4.adjustedW
        }
        
        replyCommentIcon.do {
            $0.image = .comment
        }
        
        replyCountLabel.do {
            $0.applyByeBooFont(style: .cap2R12, text: String(replyCount), color: .grayscale100)
        }
    }
    
    private func setLayout() {
        profileIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalToSuperview()
            $0.size.equalTo(20.adjustedH)
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalTo(profileIcon.snp.trailing).offset(4.adjustedW)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18.5.adjustedH)
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(4)
        }
        menuButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(24.adjustedH)
        }
        commentTextView.snp.makeConstraints {
            $0.top.equalTo(profileIcon.snp.bottom).offset(4.adjustedH)
            $0.leading.equalTo(profileIcon.snp.leading).offset(20)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(16.adjustedH)
        }
        moreLabel.snp.makeConstraints {
            $0.bottom.equalTo(commentTextView.snp.bottom)
            $0.trailing.equalTo(commentTextView.snp.trailing).offset(-20.adjustedW)
        }
    }
    
    private func setReplyLayout() {
        guard !didSetReplyLayout else { return }
        didSetReplyLayout = true

        contentView.addSubviews(replyCommentArrow, replyCountContainer)
        replyCountContainer.addArrangedSubviews(replyCommentIcon, replyCountLabel)
        
        replyCommentArrow.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedH)
            $0.size.equalTo(24.adjustedH)
        }
        replyCountContainer.snp.makeConstraints {
            $0.top.equalTo(commentTextView.snp.bottom).offset(8.adjustedH)
            $0.leading.equalTo(commentTextView.snp.leading)
            $0.height.equalTo(20.adjustedH)
            $0.bottom.equalToSuperview().inset(16.adjustedH)
        }
        replyCommentIcon.snp.makeConstraints {
            $0.size.equalTo(20.adjustedH)
        }
        profileIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalTo(replyCommentArrow.snp.trailing)
            $0.size.equalTo(20.adjustedH)
        }
        commentTextView.snp.remakeConstraints {
            $0.top.equalTo(profileIcon.snp.bottom).offset(4.adjustedH)
            $0.leading.equalTo(profileIcon.snp.leading).offset(20)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
        }
    }
}

extension CommentTableViewCell {
    func configure(
        commentID: Int,
        replyCount: Int? = nil,
        writer: String,
        profileIcon: UIImage,
        writtenAt: String,
        content: String,
        showAllText: Bool
    ) {
        if let _ = replyCount {
            setReplyLayout()
        }

        self.commentID = commentID
        nicknameLabel.text = writer
        self.profileIcon.image = profileIcon
        dateLabel.text = writtenAt
        self.content = content
        commentTextView.applyTextViewStyle(style: .body6R14, text: content, color: .grayscale100)

        layoutIfNeeded()

        if showAllText {
            commentTextView.textContainer.maximumNumberOfLines = 0
            commentTextView.textContainer.exclusionPaths = []
            commentTextView.invalidateIntrinsicContentSize()
            moreLabel.isHidden = true
        } else {
            let numberOfLines = commentTextView.numberOfLine()
            applyStyleWhenHideText(numberOfLines)
        }
    }
}

extension CommentTableViewCell {
    private func applyStyleWhenHideText(_ numberOfLines: Int) {
        moreLabel.isHidden = numberOfLines > 5 ? false : true
        commentTextView.textContainer.maximumNumberOfLines = 5
        
        let moreLabelWidth: CGFloat = moreLabel.intrinsicContentSize.width
        let contentHeight = commentTextView.sizeThatFits(
            CGSize(width: commentTextView.bounds.width, height: .infinity)
        ).height
        
        
        let lineHeight: CGFloat
        if let paragraphStyle = commentTextView.attributedText?.attribute(.paragraphStyle, at: 0, effectiveRange: nil)
            as? NSParagraphStyle,
           paragraphStyle.minimumLineHeight > 0 {
            lineHeight = paragraphStyle.minimumLineHeight
        } else {
            lineHeight = commentTextView.font?.lineHeight ?? 0
        }
        
        let exclusionRect = CGRect(
            x: commentTextView.bounds.width - moreLabelWidth - 10,
            y: contentHeight - lineHeight,
            width: moreLabelWidth,
            height: lineHeight
        )
        ByeBooLogger.debug("가로 : \(exclusionRect.width), 세로: \(exclusionRect.height)" )
        commentTextView.textContainer.exclusionPaths = [UIBezierPath(rect: exclusionRect)]
    }
    
    @objc
    private func moreLabelDidTap(_ tapRecognizer: UITapGestureRecognizer) {
        delegate?.moreLabelDidTap(commentID: commentID)
    }
}
