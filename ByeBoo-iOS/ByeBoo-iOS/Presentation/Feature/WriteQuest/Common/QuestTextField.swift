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
    let textView = UITextView()
    var textCount = UILabel()
    let placeholder: String
    private var isPlaceholderActive: Bool = true
    let limitCount: Int
    var count: Int = 0
    weak var delegate: QuestCompleteProtocol?
    
    init(type: QuestType) {
        placeholder = type.plaeholder
        limitCount = type.textLimit
        super.init(frame: .zero)
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        addSubviews(textView, textCount)
    }
    
    override func setStyle() {
        self.do {
            $0.backgroundColor = .white10
            $0.layer.cornerRadius = 12
        }
        
        textView.do {
            $0.backgroundColor = .clear
            $0.textColor = .grayscale300
            $0.text = placeholder
            $0.font = FontManager.body3R16.font
            $0.tintColor = .white
        }
        
        textCount.do {
            $0.text = "(\(count)/\(limitCount))"
            $0.font = FontManager.body6R14.font
            $0.textColor = .grayscale300
        }
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(327.adjustedW)
            $0.height.equalTo(290.adjustedH)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(34.adjustedH)
        }
        
        textCount.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(16.adjustedW)
        }
    }
}

extension QuestTextField: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isPlaceholderActive == true {
            isPlaceholderActive = false
            textView.textColor = .white
            textView.text = nil
        }
        self.layer.borderColor = UIColor.primary300.cgColor
        self.layer.borderWidth = 1
        textCount.textColor = .primary300
        textView.textColor = .white
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .grayscale300
            isPlaceholderActive = true
        }
        textView.textColor = .grayscale300
        self.layer.borderWidth = 0
        textCount.textColor = .grayscale300
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > limitCount {
            textView.deleteBackward()
        }
        count = textView.text.count
        textCount.text = "(\(count)/\(limitCount))"
        delegate?.changeStyle(count: count)
    }
}
