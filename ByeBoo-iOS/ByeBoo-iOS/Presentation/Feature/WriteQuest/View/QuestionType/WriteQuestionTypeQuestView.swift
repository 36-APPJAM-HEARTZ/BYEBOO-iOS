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
    private let descriptionView = UIStackView()
    private let descriptionLabel = UILabel()
    private let errorIcon = UIImageView()
    private(set) var confirmButton = ByeBooButton(titleText: "완료하기", type: .disabled)
    
    override func setUI() {
        addSubviews(
            title,
            questTextField,
            descriptionView,
            confirmButton
        )
        
        descriptionView.addArrangedSubviews(
            errorIcon,
            descriptionLabel
        )
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        descriptionView.do {
            $0.axis = .horizontal
            $0.spacing = 3.adjustedW
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
            $0.height.equalTo(290.adjustedH)
        }
        
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(questTextField.snp.bottom).offset(16.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
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
