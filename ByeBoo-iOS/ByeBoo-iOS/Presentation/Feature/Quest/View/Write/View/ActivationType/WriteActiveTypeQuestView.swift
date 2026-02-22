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
    private(set) var scrollView = UIScrollView()
    private let contentView = UIView()
    private(set) var title = WriteQuestTitleView(
        stepNum: "",
        stepTitle: "",
        questNum: 0,
        title: ""
    )
    
    private let imgTitleContainerView = UIView()
    private let yellowTag = ByeBooFilledTag(tagType: .yelloFilled, text: "필수")
    private let imgTitleLabel = UILabel()
    private let imgCountLabel = UILabel()
    var imgCount: Int = 0
    private(set) var imageContainer = ImagePickerContainer()
    
    private let textStackView = UIStackView()
    private let grayTag = ByeBooFilledTag(tagType: .smallGray, text: "선택")
    private let thinkTitleLabel = UILabel()
    private(set) var questTextField = QuestTextField(type: .activation)
    private(set) var confirmButton = ByeBooButton(titleText: "완료하기", type: .disabled)
    
    override func setUI() {
        addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        
        contentView.addSubviews(
            title,
            imgTitleContainerView,
            textStackView,
            imageContainer,
            questTextField,
            confirmButton
        )
        
        imgTitleContainerView.addSubviews(
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
        
        imgTitleLabel.applyByeBooFont(
            style: .body2M16,
            text: "사진 첨부",
            color: .grayscale50
        )
        
        imgCountLabel.applyByeBooFont(
            style: .body6R14,
            text: "(\(imgCount)/1)",
            color: .grayscale400
        )
        
        textStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
        
        thinkTitleLabel.applyByeBooFont(
            style: .body2M16,
            text: "생각 적기",
            color: .grayscale50
        ) 
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalToSuperview()
        }
        
        imgTitleContainerView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(8.adjustedH)
            $0.height.equalTo(24.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        
        yellowTag.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        imgTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(yellowTag.snp.trailing).offset(8.adjustedH)
            $0.centerY.equalToSuperview()
        }
        
        imgCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(imgTitleLabel.snp.trailing).offset(8.adjustedH)
            $0.centerY.equalToSuperview()
        }
        
        imageContainer.snp.makeConstraints {
            $0.top.equalTo(imgTitleContainerView.snp.bottom).offset(8.adjustedH)
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
            $0.height.greaterThanOrEqualTo(290.adjustedH)
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

extension WriteActiveTypeQuestView {
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
