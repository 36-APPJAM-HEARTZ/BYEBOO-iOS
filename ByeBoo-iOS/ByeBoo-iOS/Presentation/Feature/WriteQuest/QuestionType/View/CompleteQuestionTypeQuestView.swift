//
//  CompleteQuestionTypeQuestView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import UIKit

import SnapKit
import Then

final class CompleteQuestionTypeQuestView: BaseView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let congratSquare = CongratSquare()
    private let stepStackView = UIStackView()
    private var stepNum: Int = 0
    private let stepLabel = ByeBooYellowTag(text: "STEP 0")
    private var questNum: Int = 0
    private let questLabel = UILabel()
    private let dateText = UILabel()
    private let title = UILabel()
    private let thinkTitle = IconOneLineTextView(iconType: .think, text: "이렇게 생각했어요")
    private let changeTitle = IconOneLineTextView(iconType: .change, text: "퀘스트 완료 후, 이런 감정을 느꼈어요")
    
    override func setUI() {
        addSubviews(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            congratSquare,
            stepStackView,
            dateText,
            title,
            thinkTitle,
            changeTitle
        )
        
        stepStackView.addArrangedSubviews(stepLabel, questLabel)
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        contentView.do {
            $0.backgroundColor = .grayscale900
        }
        
        stepStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        questLabel.do {
            $0.font = FontManager.body5R14.font
            $0.textColor = .grayscale400
        }
        
        dateText.do {
            $0.font = FontManager.body5R14.font
            $0.textColor = .grayscale400
            $0.textAlignment = .center
        }
        
        title.do {
            $0.font = FontManager.head1Sb24.font
            $0.numberOfLines = 2
            $0.textColor = .grayscale100
            $0.textAlignment = .center
        }
        
    }
    
    func bind(with entity: QuestAnswerEntity) {
        self.stepNum = entity.stepNumber
        stepLabel.updateText("STEP \(stepNum)")
        self.questNum = entity.questNumber
        self.questLabel.text = "\(questNum)번째 퀘스트"
        self.title.text = entity.question
        self.dateText.text = entity.createdAt
        
        
        let thinkTextView = TextBoxView(title: entity.answer)
        let changeTextView = TextBoxView (
            title: entity.emotionDescription,
            emotionType: ByeBooEmotion.toEmotion(text: entity.questEmotionState)
        )
        
        addSubviews(thinkTextView, changeTextView)
        
        thinkTextView.isUserInteractionEnabled = false
        changeTextView.isUserInteractionEnabled = false

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
            $0.bottom.equalTo(changeTextView.snp.bottom).offset(24.adjustedH)
        }
        
        thinkTitle.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(24.5.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
        
        thinkTextView.snp.makeConstraints {
            $0.top.equalTo(thinkTitle.snp.bottom).offset(12.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
        
        changeTitle.snp.makeConstraints {
            $0.top.equalTo(thinkTextView.snp.bottom).offset(24.5.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
        
        changeTextView.snp.makeConstraints {
            $0.top.equalTo(changeTitle.snp.bottom).offset(12.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        congratSquare.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
        
        stepStackView.snp.makeConstraints {
            $0.top.equalTo(congratSquare.snp.bottom).offset(32.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(124.5.adjustedW)
            $0.width.equalTo(70.adjustedW)
        }
        
        dateText.snp.makeConstraints {
            $0.top.equalTo(stepStackView.snp.bottom).offset(12.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(147.5.adjustedW)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(dateText.snp.bottom).offset(12.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
    }
}

