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
    let title = WriteQuestTitleView(
        stepNum: "2", 
        stepTitle: "상황 정리하기", 
        questNum: 10,
        title: "연애에서 반복됐던 문제 패턴 3가지를 생각해보아요."
    )
    private let questTextField = QuestTextField(type: .question)
    private let descriptionLabel = UILabel()
    let confirmButton = ByeBooButton(titleText: "완료하기", type: .disabled)
    
    override func setUI() {
        addSubviews(
            title,
            questTextField,
            descriptionLabel,
            confirmButton
        )
        setDelegate()
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        descriptionLabel.do {
            $0.text = "* 10글자 이상 작성해주세요."
            $0.font = FontManager.cap2R12.font
            $0.textColor = .grayscale400
            $0.textAlignment = .center
        }
    }
    
    private func setDelegate() {
        questTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    override func setLayout() {
        title.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(200.adjustedH)
        }
        
        questTextField.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(24.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(290.adjustedH)
        }
        
        descriptionLabel.snp.makeConstraints {
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

extension WriteQuestionTypeQuestView: QuestCompleteProtocol {
    func changeStyle(count: Int) {
        if (count >= 10) {
            confirmButton.updateType(.enabled)
        } else {
            confirmButton.updateType(.disabled)
        }
    }
}
