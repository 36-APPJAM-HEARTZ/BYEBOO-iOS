//
//  CommentTextView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/4/26.
//

import UIKit

protocol CommonQuestCommentProtcol: AnyObject {
    func postComment(content: String)
    func editComment(content: String)
}

final class CommentTextView: BaseView {
    
    weak var delegate: CommonQuestCommentProtcol?
    
    private let topBorderLine = UIView()
    private let textFieldContainer = UIView()
    private(set) var textView = UITextView()
    private let countConfirmContainer = UIView()
    private let textCountLabel = UILabel()
    private let confirmButton = UIButton()
    
    private let placeholder: String = "댓글로 위로를 남겨보세요."
    private var isPlaceholderActive: Bool = true
    private var isEditing: Bool = false
    private let textCountLimit: Int = 500
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        addSubviews(topBorderLine,textFieldContainer, confirmButton)
        textFieldContainer.addSubviews(textView)
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        topBorderLine.do {
            $0.backgroundColor = .grayscale800
        }
        
        textFieldContainer.do {
            $0.backgroundColor = .white5
            $0.layer.cornerRadius = 8
        }
        
        textView.do {
            let offset = (FontManager.body6R14.lineHeight - FontManager.body6R14.font.lineHeight) / 2
            $0.backgroundColor = .clear
            $0.text = placeholder
            $0.font = FontManager.body6R14.font
            $0.textColor = .grayscale600
            $0.textContainerInset = .init(
                top: offset,
                left: 0,
                bottom: offset,
                right: 0
            )
            $0.isScrollEnabled = false
            $0.textContainer.maximumNumberOfLines = 1
            $0.textContainer.lineBreakMode = .byTruncatingTail
        }
        
        textCountLabel.do {
            $0.text = "0/\(textCountLimit)"
            $0.applyByeBooFont(style: .cap2R12, color: .grayscale400)
        }
        
        confirmButton.do {
            $0.applyByeBooFont(style: .body2M16, text: "완료", color: .grayscale600)
            $0.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
        }
    }
    
    override func setLayout() {
        textFieldContainer.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.trailing.equalTo(confirmButton.snp.leading).offset(-20)
            $0.height.equalTo(40.adjustedH)
            $0.bottom.equalToSuperview().inset(6.adjustedH)
        }
        
        topBorderLine.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1.adjustedH)
        }
        
        textView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(9.5.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(12.adjustedW)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17.5.adjustedH)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(21.adjustedH)
        }
    }
    
}

extension CommentTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isPlaceholderActive {
            isPlaceholderActive = false
            textView.text = ""
        }
        textView.applyTextViewStyle(style: .body6R14, text: textView.text, color: .grayscale100)
        updateTextViewLayoutWhenEditing()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textCountLabel.text = "\(textView.text.count)/500"
        let hasText = !textView.text.isEmpty
        confirmButton.isEnabled = hasText
        confirmButton.applyByeBooFont(style: .body2M16, text: "완료", color: hasText ? .primary300 : .grayscale600)

        if textView.text.count > textCountLimit {
            textView.deleteBackward()
            return
        }

        let maxHeight = 105.adjustedH
        let fittingHeight = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: .infinity)).height
        
        let shouldScroll = fittingHeight > maxHeight
        textView.isScrollEnabled = shouldScroll
        if !shouldScroll { textView.contentOffset = .zero }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        isPlaceholderActive = textView.text.isEmpty
        updateTextViewLayoutWhenEndEditing()
    }
}

extension CommentTextView {
    func configureWhenEdit(content: String) {
        textView.text = content
        isPlaceholderActive = false
        isEditing = true
    }
    
    @objc
    private func confirmButtonDidTap() {
        if isEditing {
            delegate?.editComment(content: textView.text)
        } else {
            delegate?.postComment(content: textView.text)
        }
        endEditing(true)
        textView.text = placeholder
        isPlaceholderActive = true
        isEditing = false
        textView.textColor = .grayscale600
    }
}

extension CommentTextView {
    private func updateTextViewLayoutWhenEditing() {
        textView.textContainer.maximumNumberOfLines = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
        textFieldContainer.backgroundColor = .clear
        confirmButton.removeFromSuperview()
        addSubviews(countConfirmContainer)
        countConfirmContainer.addSubviews(textCountLabel, confirmButton)
        
        textFieldContainer.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(countConfirmContainer.snp.top)
        }

        textView.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(9.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.height.greaterThanOrEqualTo(42.adjustedH)
            $0.height.lessThanOrEqualTo(105.adjustedH)
            $0.bottom.equalToSuperview().inset(9.adjustedH)
        }

        countConfirmContainer.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(8.adjustedH)
            $0.height.equalTo(40.adjustedH)
        }

        textCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(confirmButton.snp.leading).offset(-12.adjustedW)
        }

        confirmButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(40.adjustedH)
        }
    }
      
    private func updateTextViewLayoutWhenEndEditing() {
        textFieldContainer.backgroundColor = .white5
        countConfirmContainer.removeFromSuperview()
        addSubviews(confirmButton)

        textFieldContainer.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(8.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.trailing.equalTo(confirmButton.snp.leading).offset(-20)
            $0.height.equalTo(40.adjustedH)
            $0.bottom.equalToSuperview().inset(6.adjustedH)
        }

        textView.snp.remakeConstraints {
            $0.verticalEdges.equalToSuperview().inset(9.5.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(12.adjustedW)
        }

        confirmButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17.5.adjustedH)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(21.adjustedH)
        }

        textView.isScrollEnabled = false
        textView.textContainer.maximumNumberOfLines = 1
        textView.textContainer.lineBreakMode = .byTruncatingTail

        let text = isPlaceholderActive ? placeholder : (textView.text ?? "")
        let color: UIColor = isPlaceholderActive ? .grayscale600 : .grayscale100
        textView.typingAttributes = [.font: FontManager.body6R14.font, .foregroundColor: color]
        textView.text = text
        textView.textColor = color
    }
}
