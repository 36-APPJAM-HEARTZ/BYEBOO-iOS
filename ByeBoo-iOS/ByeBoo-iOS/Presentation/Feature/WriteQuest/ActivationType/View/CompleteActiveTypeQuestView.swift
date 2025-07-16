//
//  CompleteActiveTypeQuestView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import UIKit

import SnapKit
import Then

final class CompleteActiveTypeQuestView: BaseView {
    
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
    
    override func setUI() {
        addSubviews(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            congratSquare,
            stepStackView,
            dateText,
            title
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
            $0.distribution = .equalCentering
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
            $0.numberOfLines = 0
            $0.textColor = .grayscale100
            $0.textAlignment = .center
            $0.lineBreakMode = .byWordWrapping
        }
    }
    
    func bind(with entity: QuestAnswerEntity) {
        self.stepNum = entity.stepNumber
        stepLabel.updateText("STEP \(stepNum)")
        self.questNum = entity.questNumber
        self.questLabel.text = "\(questNum)번째 퀘스트"
        self.title.text = entity.question
        self.dateText.text = entity.createdAt.dateFormat()
        
        let actionView = ActionView(descriptionText: entity.answer, photoURL: entity.imageUrl!)
        let feelView = FeelView(
            emotionType: entity.questEmotionState,
            descriptionText: entity.emotionDescription
        )

        contentView.addSubviews(actionView, feelView)

        actionView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        feelView.snp.makeConstraints {
            $0.top.equalTo(actionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24.adjustedH)
        }
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        
        congratSquare.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
        
        stepStackView.snp.makeConstraints {
            $0.top.equalTo(congratSquare.snp.bottom).offset(32.adjustedH)
            $0.centerX.equalToSuperview()
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
