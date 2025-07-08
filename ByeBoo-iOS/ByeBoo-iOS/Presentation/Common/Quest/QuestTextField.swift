//
//  QuestTextField.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/8/25.
//

import UIKit

import SnapKit
import Then

enum QuestType {
    case question
    case activation
    
    var plaeholder: String {
        switch self {
        case .question:
            return "글로 적다 보면, 스스로에게 한 걸음 더 가까워질 수 있어요."
        case .activation:
            return "꼭 적지 않아도 괜찮지만, 글로 정리해보면 스스로에게 한 걸음 더 가까워질 수 있어요."
        }
    }
}

final class QuestTextField: BaseView {
    let textView = UITextView()
    private let textCount = UILabel()
    private let placeholder: String
    private var isPlaceholderActive: Bool = true
    private var count: Int = 0
    
    init(type: QuestType) {
        placeholder = type.plaeholder
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
        textView.do {
            $0.backgroundColor = .white10
            $0.layer.cornerRadius = 12
            $0.textColor = .grayscale300
            $0.text = placeholder
            $0.font = FontManager.body3R16.font
            $0.textContainerInset = UIEdgeInsets(top: 16.adjustedH, left: 24.adjustedW, bottom: 34.adjustedH, right: 24.adjustedW)
        }
        
        textCount.do {
            $0.text = "(\(count)/500)"
            $0.font = FontManager.body5R14.font
            $0.textColor = .grayscale300
        }
    }
    
    override func setLayout() {
        textView.snp.makeConstraints {
            $0.width.equalTo(327.adjustedW)
            $0.height.equalTo(290.adjustedH)
        }
        
        textCount.snp.makeConstraints {
            $0.trailing.equalTo(textView.snp.trailing).inset(24)
            $0.bottom.equalTo(textView.snp.bottom).inset(16.adjustedW)
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
        print("이 텍스트뷰가 firstResponder? \(textView.isFirstResponder)")
        textView.layer.borderColor = UIColor.primary300.cgColor
        textView.layer.borderWidth = 1
        textCount.textColor = .primary300
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .grayscale300
            isPlaceholderActive = true
        }
        textView.textColor = .grayscale300
        textView.layer.borderWidth = 0
        textCount.textColor = .grayscale300
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 500 {
            textView.deleteBackward()
            textView.layer.borderColor = UIColor.error300.cgColor
            textView.layer.borderWidth = 1
            textCount.textColor = .error300
        }
        
        count = textView.text.count
        textCount.text = "(\(count)/500)"
    }
}
