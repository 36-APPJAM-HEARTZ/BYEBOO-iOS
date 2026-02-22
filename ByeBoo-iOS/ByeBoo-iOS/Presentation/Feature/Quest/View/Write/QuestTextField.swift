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
    private var descriptionStackView: UIStackView?
    private let errorIcon = UIImageView()
    private let descriptionLabel = UILabel()
    private(set) var textCountLabel = UILabel()
    
    private var questType: QuestType
    var isPlaceholderActive: Bool = true
    var count: Int = 0
    private(set) var  placeholder: String
    private(set) var  limitCount: Int
    private var containerHeightConsraint: Constraint?
    private var textViewHeightConstraint: Constraint?
    
    weak var delegate: QuestCompleteProtocol?
    
    init(type: QuestType) {
        self.questType = type
        placeholder = type.plaeholder
        limitCount = type.textLimit
        
        switch type {
        case .question:
            descriptionStackView = UIStackView()
        case .activation:
            descriptionStackView = nil
        }
        
        super.init(frame: .zero)
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        addSubviews(textView, textCountLabel)
        
        if let descriptionStackView {
            addSubviews(descriptionStackView)
            descriptionStackView.addArrangedSubviews(errorIcon, descriptionLabel)
        }
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
        
        textCountLabel.applyByeBooFont (
            style: .cap2R12,
            text: "(\(count)/\(limitCount))",
            color: .grayscale400
        )
        
        if let descriptionStackView {
            descriptionStackView.do {
                $0.axis = .horizontal
                $0.spacing = 3.adjustedW
            }
        }
        
        errorIcon.do {
            $0.image = .error
            $0.contentMode = .scaleAspectFit
        }
        
        descriptionLabel.applyByeBooFont(
            style: .cap2R12,
            text: "10글자 이상 작성해 주세요.",
            color: .grayscale400,
            textAlignment: .center
        )
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(327.adjustedW)
            containerHeightConsraint = $0.height.equalTo(268.adjustedH).constraint
        }
        
        textView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            textViewHeightConstraint = $0.height.equalTo(196.adjustedH).constraint
        }
        
        if let descriptionStackView {
            descriptionStackView.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.bottom.equalToSuperview().inset(24.adjustedW)
            }
        }
        
        textCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24.adjustedW)
        }
    }
}

extension QuestTextField: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isPlaceholderActive == true {
            isPlaceholderActive = false
            applyTextViewStyle(text: "", color: .grayscale100)
        }
        textView.textColor = .grayscale100
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            applyTextViewStyle(text: placeholder, color: .grayscale300)
            isPlaceholderActive = true
        } else {
            applyTextViewStyle(text: textView.text, color: .grayscale100)
        }
        textCountLabel.textColor = .grayscale300
        updateTextViewHeight()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > limitCount {
            textView.deleteBackward()
        }
        count = textView.text.count
        textCountLabel.text = "(\(count)/\(limitCount))"
        updateTextViewHeight()
        delegate?.updateButtonWhenWriting(text: textView.text)
    }
}

extension QuestTextField {
    func applyTextViewStyle(text: String, color: UIColor) {
        textView.applyByeBooFont(
            style: .body3R16,
            text: text,
            color: color
        )
    }
    
    func updateTextViewHeight() {
        let width = self.frame.width
        let fittingSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let estimatedHeight = ceil(textView.sizeThatFits(fittingSize).height)
        let containerMinHeight = 268.adjustedH
        let textViewMinHeight = 196.adjustedH
        
        containerHeightConsraint?.update(offset: max(containerMinHeight, estimatedHeight + 72.adjustedH))
        textViewHeightConstraint?.update(offset: max(textViewMinHeight, estimatedHeight))
        superview?.layoutIfNeeded()
        layoutIfNeeded()
    }
}
