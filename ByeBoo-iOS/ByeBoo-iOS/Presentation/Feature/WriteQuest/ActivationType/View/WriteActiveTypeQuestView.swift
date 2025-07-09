//
//  WriteActiveTypeQuestView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/8/25.
//

import UIKit

import SnapKit
import Then

final class WriteActiveTypeQuestView: BaseView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    private let title = WriteQuestTitleView(
        stepNum: "2",
        stepTitle: "감정 정리하기",
        questNum: 10,
        title: "오늘은 나가서 상쾌하게 달리고 오세요."
    )
    
    private let imgStackView = UIStackView()
    private let yellowTag = ByeBooFilledTag(tagType: .yelloFilled, text: "필수")
    private let imgTitleLabel = UILabel()
    private let imgCountLabel = UILabel()
    var imgCount: Int = 0
    let imageContainer = ImagePickerContainer()
    
    private let textStackView = UIStackView()
    private let grayTag = ByeBooFilledTag(tagType: .smallGray, text: "선택")
    private let thinkTitleLabel = UILabel()
    private let questTextField = QuestTextField(type: .activation)
    let confirmButton = ByeBooButton(titleText: "완료하기", type: .disabled)
    
    override func setUI() {
        addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        
        contentView.addSubviews(
            title,
            imgStackView,
            textStackView,
            imageContainer,
            questTextField,
            confirmButton
        )
        
        imgStackView.addArrangedSubviews(
            yellowTag, imgTitleLabel, imgCountLabel
        )
        
        textStackView.addArrangedSubviews(
            grayTag, thinkTitleLabel
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
        
        imgStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
        
        imgTitleLabel.do {
            $0.text = "사진 첨부"
            $0.font = FontManager.body2M16.font
            $0.textColor = .grayscale50
        }
        
        imgCountLabel.do {
            $0.text = "(\(imgCount)/1)"
            $0.font = FontManager.body5R14.font
            $0.textColor = .grayscale400
        }
        
        textStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
        
        thinkTitleLabel.do {
            $0.text = "생각 적기"
            $0.font = FontManager.body2M16.font
            $0.textColor = .grayscale50
        }
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
            $0.bottom.equalTo(confirmButton.snp.bottom).offset(24.adjustedH)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(200.adjustedH)
        }
        
        imgStackView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(24.adjustedH)
            $0.width.equalTo(165.adjustedW)
            $0.height.equalTo(24.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        
        imageContainer.snp.makeConstraints {
            $0.top.equalTo(imgStackView.snp.bottom).offset(8.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.width.height.equalTo(96.adjustedW)
        }
        
        textStackView.snp.makeConstraints {
            $0.top.equalTo(imageContainer.snp.bottom).offset(16.adjustedH)
            $0.width.equalTo(327.adjustedW)
            $0.height.equalTo(24.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
        
        questTextField.snp.makeConstraints {
            $0.top.equalTo(textStackView.snp.bottom).offset(8.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(290.adjustedH)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(questTextField.snp.bottom).offset(28.adjustedH)
            $0.height.equalTo(53.adjustedH)
            $0.width.equalTo(311.adjustedW)
            $0.bottom.equalToSuperview().inset(24.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
    
    func updateImageCountLabel(count: Int) {
        imgCountLabel.text = "(\(count)/1)"
    }
}

extension WriteActiveTypeQuestView: QuestCompleteProtocol {
    func changeStyle(count: Int) {
        if count == 1 {
            confirmButton.updateType(.enabled)
        }
    }
}
