//
//  WriteQuestionTypeView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/8/25.
//

import UIKit

import SnapKit
import Then

final class WriteQuestionTypeQuestView: BaseView {
    private let questScope: QuestScope
    private(set) var scrollView = UIScrollView()
    private let contentView = UIView()
    private(set) var headerView = WriteQuestTitleView(questScope: .personal, questNum: 0, title: "")
    private let divider = UIView()
    private(set) var questTextField = QuestTextField(type: .question)
    
    init(questScope: QuestScope) {
        self.questScope = questScope
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            headerView,
            divider,
            questTextField
        )
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        scrollView.do {
            $0.isScrollEnabled = true
            $0.keyboardDismissMode = .onDrag
            $0.backgroundColor = .clear
            $0.isUserInteractionEnabled = true
        }
        
        contentView.do {
            $0.backgroundColor = .grayscale900
            $0.isUserInteractionEnabled = true
        }
        
        divider.do {
            $0.backgroundColor = .grayscale800
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(questTextField.snp.bottom).offset(12.adjustedH)
            $0.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide).priority(250)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(1.adjustedH)
        }
        
        questTextField.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(20.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.greaterThanOrEqualTo(268.adjustedH)
        }
    }
}

extension WriteQuestionTypeQuestView: WriteQuestBaseProtocol {
    var questTextView: UITextView {
        questTextField.textView
    }
    var questCountLabelView: UIView {
        questTextField.textCountLabel
    }
    var tipTagView: UIView {
        headerView.tipTag
    }
}

extension WriteQuestionTypeQuestView {
    func updateQuestTitle(
        questScope: QuestScope,
        questNumber: Int,
        questStyle: String,
        question: String
    ) {
        headerView.bind(
            questScope: questScope,
            questNum: questNumber,
            title: question
        )
    }
}
