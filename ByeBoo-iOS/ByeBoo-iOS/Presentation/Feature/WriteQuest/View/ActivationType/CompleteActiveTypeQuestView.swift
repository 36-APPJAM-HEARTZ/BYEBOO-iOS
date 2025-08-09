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
    private var headerView = ArchiveQuestHeaderView(
        type: .complete,
        stepNumber: 0,
        questNumber: 0,
        date: "",
        questTitle:""
    )
    
    override func setUI() {
        addSubviews(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            congratSquare,
            headerView
        )
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        contentView.do {
            $0.backgroundColor = .grayscale900
        }
    }
    
    func bind(with entity: QuestAnswerEntity) {
        headerView.updateUI(
            stepNumber: entity.stepNumber,
            questNumber: entity.questNumber,
            date: entity.createdAt,
            title: entity.question
        )
        
        guard let imageUrl = entity.imageUrl else { return }
        let actionView = ActionView(descriptionText: entity.answer, photoURL: imageUrl)
        
        let feelView = FeelView(
            emotionType: entity.questEmotionState,
            descriptionText: entity.emotionDescription
        )

        contentView.addSubviews(actionView, feelView)

        actionView.snp.makeConstraints {
            $0.top.equalTo(headerView.questTitleLabel.snp.bottom)
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
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(congratSquare.snp.bottom).offset(32.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
