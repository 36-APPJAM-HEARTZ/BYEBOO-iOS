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
    private(set) var  limitCount: Int = QuestType.activation.textLimit
    var count: Int = 0
    
    private(set) var scrollView = UIScrollView()
    private let contentView = UIView()

    private(set) var headerView = WriteQuestTitleView(questNum: 0, title: "")
    private let divider = UIView()
    
    private let imgTitleContainerView = UIView()
    private let yellowTag = ByeBooFilledTag(tagType: .yelloFilled, text: "필수")
    private let imgTitleLabel = UILabel()
    private let imgCountLabel = UILabel()
    var imgCount: Int = 0
    private(set) var imageContainer = ImagePickerContainer()
    
    private let questFieldTitleView = UIView()
    private let grayTag = ByeBooFilledTag(tagType: .smallGray, text: "선택")
    private let thinkTitleLabel = UILabel()
    private(set) var questTextField = QuestTextField(type: .activation)
    
    private let bottomContainerView = UIView()
    private(set) var textCountLabel = UILabel()
    private var bottomConstraint: Constraint?
    private var contentViewBottomConstraint: Constraint?
    
    override func setUI() {
        addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        
        contentView.addSubviews(
            headerView,
            divider,
            imgTitleContainerView,
            questFieldTitleView,
            imageContainer,
            questTextField,
            bottomContainerView
        )
        
        imgTitleContainerView.addSubviews(
            yellowTag, imgTitleLabel, imgCountLabel
        )
        
        questFieldTitleView.addSubviews(
            grayTag, thinkTitleLabel
        )
        
        bottomContainerView.addSubview(textCountLabel)
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        scrollView.do {
            $0.isScrollEnabled = true
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
        
        thinkTitleLabel.applyByeBooFont(
            style: .body2M16,
            text: "생각 적기",
            color: .grayscale50
        )
        
        bottomContainerView.backgroundColor = .grayscale900
        
        textCountLabel.applyByeBooFont (
            style: .cap2R12,
            text: "\(count)/\(limitCount)",
            color: .grayscale400
        )
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide).priority(250)
            contentViewBottomConstraint =
            $0.bottom.equalTo(bottomContainerView.snp.bottom).offset(32.adjustedH).constraint
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
        
        imgTitleContainerView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(20.adjustedH)
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
            $0.top.equalTo(imgTitleContainerView.snp.bottom).offset(12.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.width.height.equalTo(327.adjustedW)
        }
        
        questFieldTitleView.snp.makeConstraints {
            $0.top.equalTo(imageContainer.snp.bottom).offset(16.adjustedH)
            $0.height.equalTo(24.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        
        grayTag.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        thinkTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(grayTag.snp.trailing).offset(8.adjustedH)
            $0.centerY.equalToSuperview()
        }
        
        questTextField.snp.makeConstraints {
            $0.top.equalTo(questFieldTitleView.snp.bottom).offset(12.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.greaterThanOrEqualTo(280.adjustedH)
        }
        
        bottomContainerView.snp.makeConstraints {
            $0.top.equalTo(questTextField.snp.bottom).offset(32.adjustedH)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(42.adjustedH)
        }
        
        textCountLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(13.adjustedH)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func updateImageCountLabel(count: Int) {
        imgCountLabel.text = "\(count)/1"
    }
}

extension WriteActiveTypeQuestView: WriteQuestBaseProtocol {
    var questTextView: QuestTextField {
        questTextField
    }
    var questCountLabelView: UILabel {
        textCountLabel
    }
    var tipTagView: UIView {
        headerView.tipTag ?? UIView()
    }
    var bottomView: UIView {
        bottomContainerView
    }
}

extension WriteActiveTypeQuestView {
    func updateQuestTitle(
        questScope: QuestScope? = nil,
        questNumber: Int,
        question: String
    ) {
        headerView.bind(
            questScope: questScope,
            questNum: questNumber,
            title: question
        )
    }
}

extension WriteActiveTypeQuestView: UpdateUIWhenKeyboardProtocol {
    func updateUIWhenKeyboardUp() {
        bottomContainerView.removeFromSuperview()
        addSubview(bottomContainerView)
        bottomContainerView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(42.adjustedH)
            bottomConstraint = $0.bottom.equalToSuperview().constraint
        }
        
        contentView.snp.remakeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide).priority(250)
        }
        questTextField.snp.remakeConstraints {
            $0.top.equalTo(questFieldTitleView.snp.bottom).offset(12.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.greaterThanOrEqualTo(280.adjustedH)
            $0.bottom.equalToSuperview().inset(17.adjustedH)
        }
    }
    
    func updateUIWhenKeyboardDown() {
        bottomContainerView.removeFromSuperview()
        contentView.addSubview(bottomContainerView)
        questTextField.snp.remakeConstraints {
            $0.top.equalTo(questFieldTitleView.snp.bottom).offset(12.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.greaterThanOrEqualTo(280.adjustedH)
        }
        
        bottomContainerView.snp.remakeConstraints {
            $0.top.equalTo(questTextField.snp.bottom).offset(32.adjustedH)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24.adjustedH)
            $0.height.equalTo(42.adjustedH)
        }
        
        contentView.snp.remakeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide).priority(250)
        }
    }

    func updateBottomConstraint(_ offset: CGFloat) {
        bottomConstraint?.update(offset: offset)
    }
}

