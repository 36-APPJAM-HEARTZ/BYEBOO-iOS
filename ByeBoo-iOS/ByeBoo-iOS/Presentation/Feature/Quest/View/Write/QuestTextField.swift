//
//  QuestTextField.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/8/25.
//

import UIKit

import SnapKit
import Then

final class QuestTextField: BaseView {
    private(set) var textView = UITextView()
    private var questType: QuestType
    
    var isPlaceholderActive: Bool = true
    var count: Int = 0
    private(set) var  placeholder: String
    private(set) var  limitCount: Int
    private var containerHeightConsraint: Constraint?
    private var textViewHeightConstraint: Constraint?
    private var lastTextViewHeight = 196.adjustedH
    
    weak var questCompleteDelegate: QuestCompleteProtocol?
    weak var questTextViewDelegate: WriteQuestTextViewProtocol?
    
    init(type: QuestType) {
        self.questType = type
        placeholder = type.plaeholder
        limitCount = type.textLimit
        super.init(frame: .zero)
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        addSubviews(textView)
    }
    
    override func setStyle() {
        self.do {
            $0.backgroundColor = .clear
        }
        
        textView.do {
            $0.backgroundColor = .clear
            $0.tintColor = .grayscale100
            $0.isScrollEnabled = false
            $0.applyByeBooFont(
                style: .body3R16,
                text: placeholder,
                color: .grayscale300
            )
        }
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(327.adjustedW)
            containerHeightConsraint = $0.height.greaterThanOrEqualTo(268.adjustedH).constraint
        }
        
        textView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(72.adjustedH)
            textViewHeightConstraint = $0.height.equalTo(196.adjustedH).constraint
        }
    }
}

extension QuestTextField: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isPlaceholderActive == true {
            isPlaceholderActive = false
            textView.applyTextViewStyle(style: .body3R16 ,text: "", color: .grayscale100)
        }
        textView.textColor = .grayscale100
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.applyTextViewStyle(style: .body3R16 ,text: placeholder, color: .grayscale300)
            isPlaceholderActive = true
        } else {
            textView.applyTextViewStyle(style: .body3R16, text: textView.text, color: .grayscale100)
        }
        questTextViewDelegate?.textViewDidEndEditing()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > limitCount {
            textView.deleteBackward()
        }
        questCompleteDelegate?.updateButtonWhenWriting(text: textView.text)
        questTextViewDelegate?.textViewDidChange(count: textView.text.count)
    }
}

extension QuestTextField {
    func updateTextViewHeight() -> CGFloat {
        let width = self.frame.width
        let fittingSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let estimatedHeight = ceil(textView.sizeThatFits(fittingSize).height)
        let containerMinHeight = 268.adjustedH
        let textViewMinHeight = 196.adjustedH
        
        let newHeight = max(textViewMinHeight, estimatedHeight)
        let diff = newHeight - lastTextViewHeight

        containerHeightConsraint?.update(offset: max(containerMinHeight, estimatedHeight + 72.adjustedH))
        textViewHeightConstraint?.update(offset: max(textViewMinHeight, estimatedHeight))
        UIView.performWithoutAnimation {
            self.superview?.layoutIfNeeded()
            self.layoutIfNeeded()
        }

        lastTextViewHeight = newHeight
        
        return diff
    }
}
