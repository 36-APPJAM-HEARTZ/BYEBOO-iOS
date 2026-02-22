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
    private(set) var headerView = WriteQuestTitleView(questNum: 0, title: "")
    private let divider = UIView()
    private(set) var questTextField = QuestTextField(type: .question)
    
    override func setUI() {
        addSubviews(
            headerView,
            divider,
            questTextField
        )
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        divider.do {
            $0.backgroundColor = .grayscale800
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    override func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
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

extension WriteQuestionTypeQuestView {
    func updateQuestTitle(
        questNumber: Int,
        questStyle: String,
        question: String
    ) {
        headerView.bind(
            questNum: questNumber,
            title: question
        )
    }
}
