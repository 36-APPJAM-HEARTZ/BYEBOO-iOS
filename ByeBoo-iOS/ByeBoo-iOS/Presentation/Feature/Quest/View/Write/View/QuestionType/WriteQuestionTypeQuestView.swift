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
    private(set) var  limitCount: Int = QuestType.question.textLimit
    var count: Int = 0
    
    private(set) var scrollView = UIScrollView()
    private let contentView = UIView()
    
    private(set) var headerView = WriteQuestTitleView(questNum: 0, title: "")
    private let divider = UIView()
    private(set) var questTextField = QuestTextField(type: .question)
    private var descriptionStackView = UIStackView()
    private let descriptionLabel = UILabel()
    private(set) var textCountLabel = UILabel()
    private let errorIcon = UIImageView()
    private let bottomContainerView = UIView()
    
    private var bottomConstraint: Constraint?
    private var contentViewBottomConstraint: Constraint?
    
    init(questScope: QuestScope) {
        self.questScope = questScope
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        addSubviews(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            headerView,
            divider,
            questTextField,
            bottomContainerView
        )
        bottomContainerView.addSubviews(descriptionStackView, textCountLabel)
        descriptionStackView.addArrangedSubviews(errorIcon, descriptionLabel)
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
        
        descriptionStackView.do {
            $0.axis = .horizontal
            $0.spacing = 3.adjustedW
        }
        
        textCountLabel.applyByeBooFont (
            style: .cap2R12,
            text: "\(count)/\(limitCount)",
            color: .grayscale400
        )
        
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
        
        bottomContainerView.backgroundColor = .grayscale900
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
        
        questTextField.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(20.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.greaterThanOrEqualTo(268.adjustedH)
        }
        
        bottomContainerView.snp.makeConstraints {
            $0.top.equalTo(questTextField.snp.bottom).offset(32.adjustedH)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56.adjustedH)
        }
        
        descriptionStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(13.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }

        textCountLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(13.adjustedH)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
        }
    }
}

extension WriteQuestionTypeQuestView: WriteQuestBaseProtocol {
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

extension WriteQuestionTypeQuestView {
    func updateQuestTitle(
        questScope: QuestScope,
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

extension WriteQuestionTypeQuestView: UpdateUIWhenKeyboardProtocol {    
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
            $0.top.equalTo(divider.snp.bottom).offset(20.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.greaterThanOrEqualTo(280.adjustedH)
            $0.bottom.equalToSuperview().inset(17.adjustedH)
        }
    }
    
    func updateUIWhenKeyboardDown() {
        bottomContainerView.removeFromSuperview()
        contentView.addSubview(bottomContainerView)
        
        questTextField.snp.remakeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(20.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.greaterThanOrEqualTo(280.adjustedH)
        }
        
        bottomContainerView.snp.remakeConstraints {
            $0.top.equalTo(questTextField.snp.bottom).offset(32.adjustedH)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(17.adjustedH)
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
