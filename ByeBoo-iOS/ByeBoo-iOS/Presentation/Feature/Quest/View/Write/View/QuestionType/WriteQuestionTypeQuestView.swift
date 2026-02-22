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
    private(set) var title = WriteQuestTitleView(
        stepNum: "",
        stepTitle: "",
        questNum: 0,
        title: ""
    )
    private(set) var questTextField = QuestTextField(type: .question)
    private(set) var confirmButton = ByeBooButton(titleText: "완료하기", type: .disabled)
    
    override func setUI() {
        addSubviews(
            title,
            questTextField,
            confirmButton
        )
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    override func setLayout() {
        title.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        questTextField.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(8.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.greaterThanOrEqualTo(268.adjustedH)
        }
        
        confirmButton.snp.makeConstraints {
            $0.width.equalTo(311.adjustedW)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
    }
}

extension WriteQuestionTypeQuestView {
    func updateQuestTitle(
        step: String,
        stepNum: Int,
        questNumber: Int,
        questStyle: String,
        question: String
    ) {
        title.bind(
            stepNum: String(stepNum),
            stepTitle: step,
            questNum: questNumber,
            title: question
        )
    }
}
