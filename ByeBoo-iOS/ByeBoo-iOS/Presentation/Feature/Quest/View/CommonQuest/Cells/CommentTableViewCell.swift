//
//  CommentCellTableViewCell.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/4/26.
//

import UIKit

protocol CommentProtocol: AnyObject {
    func moreLabelDidTap(commentID: Int)
    func replyIconDidTap(commentID: Int)
    func menuButtonDidTap(commentID: Int, isMyComment: Bool)
}

extension CommentProtocol {
    func replyIconDidTap(commentID: Int) { }
}

final class CommentTableViewCell: UITableViewCell {
    
    weak var delegate: CommentProtocol?
    
    private var replyCommentArrow = UIImageView()
    private var replyCommentContainer = UIView()
    private let profileIcon = UIImageView(image: .relievedBadge)
    private let nicknameLabel = UILabel()
    private let dateLabel = UILabel()
    private let menuButton = UIButton()
    private let commentTextView = UITextView()
    private var moreLabel = UILabel()
    private var replyCountContainer = UIStackView()
    private var replyCommentIcon = UIImageView()
    private var replyCountLabel = UILabel()
    
    private var replyCount: Int = 0
    private var commentID: Int = 0
    private var content: String = ""
    private var didSetReplyLayout = false
    private var didSetCommentLayout = false
    
    private var isMyComment: Bool = false
    
    private var showAllText: Bool = false
    private var lastTruncationWidth: CGFloat = -1
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setStyle()
        setLayout()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // bounds.width가 이 기기 폭으로 확정된 뒤에만 계산해야 기기별 오차가 없다.
        let width = commentTextView.bounds.width
        guard width > 0, width != lastTruncationWidth else { return }
        lastTruncationWidth = width

        updateTextTruncation()
    }
    
    // exclusionPaths 변경으로 layoutSubviews가 재호출돼도 width는 안 바뀌므로 위 guard에서 걸러진다.
    private func updateTextTruncation() {
        commentTextView.textContainer.maximumNumberOfLines = 0
        commentTextView.textContainer.exclusionPaths = []
        
        if showAllText {
            commentTextView.invalidateIntrinsicContentSize()
            moreLabel.isHidden = true
        } else {
            applyStyleWhenHideText()
        }
    }
    
    private func setUI() {
        contentView.addSubviews(profileIcon, nicknameLabel, dateLabel, menuButton, commentTextView, moreLabel)
    }
    
    private func setStyle() {
        backgroundColor = .grayscale900
        selectionStyle = .none
        
        replyCommentArrow.do {
            $0.image = .replyArrow
        }
        
        nicknameLabel.do {
            $0.applyByeBooFont(style: .body5M14, color: .grayscale200)
        }
        
        dateLabel.do {
            $0.applyByeBooFont(style: .cap2R12, color: .grayscale400)
        }
        
        menuButton.do {
            $0.setImage(.menu, for: .normal)
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
        }
        
        replyCountContainer.do {
            $0.axis = .horizontal
            $0.spacing = 4.adjustedW
        }
        
        replyCommentIcon.do {
            $0.image = .comment.withRenderingMode(.alwaysTemplate)
            $0.isUserInteractionEnabled = true
            $0.tintColor = .grayscale100
        }
        
        replyCountLabel.do {
            $0.applyByeBooFont(style: .cap2R12, text: String(replyCount), color: .grayscale100)
        }
    }
    
    private func setLayout() {
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
        moreLabel.snp.makeConstraints {
            $0.bottom.equalTo(commentTextView.snp.bottom)
            $0.trailing.equalTo(commentTextView.snp.trailing).offset(-20.adjustedW)
        }
    }
    
    private func setCommentListLayout() {
        guard !didSetCommentLayout else { return }
        didSetCommentLayout = true

        contentView.addSubview(replyCountContainer)
        replyCountContainer.addArrangedSubviews(replyCommentIcon, replyCountLabel)
        
        profileIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalToSuperview()
            $0.size.equalTo(20.adjustedH)
        }
        commentTextView.snp.makeConstraints {
            $0.top.equalTo(profileIcon.snp.bottom).offset(4.adjustedH)
            $0.leading.equalTo(profileIcon.snp.leading).offset(20)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(44.adjustedH)
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
    }
    
    private func setReplySheetLayout() {
        guard !didSetReplyLayout else { return }
        didSetReplyLayout = true

        contentView.addSubviews(replyCommentArrow)
    
        replyCommentArrow.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalToSuperview()
            $0.size.equalTo(24.adjustedH)
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
            $0.bottom.equalToSuperview().inset(16.adjustedH)
        }
    }
    
    private func setAddTarget() {
        let moreLabelTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(moreLabelDidTap(_:)))
        moreLabel.addGestureRecognizer(moreLabelTapRecognizer)
        
        let replyTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(replyIconDidTap(_:)))
        replyCommentIcon.addGestureRecognizer(replyTapRecognizer)
        
        menuButton.addTarget(self, action: #selector(menuButtonDidTap), for: .touchUpInside)
    }
}

extension CommentTableViewCell {
    func configure(
        isMyComment: Bool,
        commentID: Int,
        replyCount: Int? = nil,
        writer: String,
        profileIcon: UIImage,
        writtenAt: String,
        content: String,
        showAllText: Bool,
        isReplySheet: Bool
    ) {
        if let replyCount {
            setCommentListLayout()
            updateReplyCount(replyCount: replyCount)
        } else {
            setReplySheetLayout()
        }
        
        if isReplySheet {
            replyCommentIcon.tintColor = .grayscale600
            replyCountLabel.textColor = .grayscale600
        }
        
        self.isMyComment = isMyComment
        self.commentID = commentID
        nicknameLabel.text = writer
        self.profileIcon.image = profileIcon
        dateLabel.text = writtenAt
        self.content = content
        self.showAllText = showAllText
        commentTextView.applyTextViewStyle(style: .body6R14, text: content, color: .grayscale100)

        commentTextView.textContainer.maximumNumberOfLines = 0
        commentTextView.textContainer.exclusionPaths = []

        // setNeedsLayout만으로는 부족하다: commentListView가 스크롤 없는 self-sizing 테이블이라
        // 일반 테이블처럼 셀이 화면에 나타날 때 자연스럽게 layoutSubviews가 재호출되지 않는다.
        // layoutIfNeeded로 직접 트리거해야 truncation 계산(layoutSubviews)이 그 자리에서 실행된다.
        lastTruncationWidth = -1
        layoutIfNeeded()
    }
    
    func updateReplyCount(replyCount: Int) {
        self.replyCount = replyCount
        replyCountLabel.text = "\(replyCount)"
    }
}

extension CommentTableViewCell {
    private func applyStyleWhenHideText() {
        let textContainer = commentTextView.textContainer
        let layoutManager = commentTextView.layoutManager

        // textContainer.size는 UITextView가 자기 layoutSubviews에서 뒤늦게 동기화하므로 직접 맞춰준다.
        textContainer.size = CGSize(width: commentTextView.bounds.width, height: .greatestFiniteMagnitude)
        textContainer.maximumNumberOfLines = 5

        // glyphRange(for:)는 잘려도 전체 glyph 수를 그대로 반환해 truncation 판단에 못 쓴다.
        // 마지막 줄이 실제로 잘렸는지는 truncatedGlyphRange(inLineFragmentForGlyphAt:)로 확인한다.
        layoutManager.ensureLayout(for: textContainer)
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        var isTruncated = false
        if glyphRange.length > 0 {
            let lastGlyphIndex = NSMaxRange(glyphRange) - 1
            let truncatedRange = layoutManager.truncatedGlyphRange(inLineFragmentForGlyphAt: lastGlyphIndex)
            isTruncated = truncatedRange.location != NSNotFound
        }

        moreLabel.isHidden = !isTruncated

        guard isTruncated else {
            commentTextView.textContainer.exclusionPaths = []
            return
        }

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
        commentTextView.textContainer.exclusionPaths = [UIBezierPath(rect: exclusionRect)]
    }
    
    @objc
    private func moreLabelDidTap(_ tapRecognizer: UITapGestureRecognizer) {
        delegate?.moreLabelDidTap(commentID: commentID)
    }
    
    @objc
    private func replyIconDidTap(_ tapRecognizer: UITapGestureRecognizer) {
        delegate?.replyIconDidTap(commentID: commentID)
    }
    
    @objc
    private func menuButtonDidTap() {
        delegate?.menuButtonDidTap(commentID: commentID, isMyComment: isMyComment)
    }
}
