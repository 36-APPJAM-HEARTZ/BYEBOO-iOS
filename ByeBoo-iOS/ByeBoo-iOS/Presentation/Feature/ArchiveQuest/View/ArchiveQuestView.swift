//
//  ArchiveQuestView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

import Then
import SnapKit

final class ArchiveQuestView: BaseView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var headerView = ArchiveQuestHeaderView(
        type: .archive,
        stepNumber: 0,
        questNumber: 0,
        date: "",
        questTitle:""
    )
    private let thinkView: ThinkView?
    private let actionView: ActionView?
    private var feelView = FeelView(emotionType: "", descriptionText: "")
    
    private let type: QuestType
    
    init(type: QuestType) {
        self.type = type
        
        switch type {
        case .question:
            thinkView = ThinkView(descriptionText: "")
            actionView = nil
        case .activation:
            thinkView = nil
            actionView = ActionView(descriptionText: "", photoURL: "")
        }
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        actionView?.do {
            $0.isUserInteractionEnabled = false
        }
        thinkView?.do {
            $0.isUserInteractionEnabled = false
        }
    }
    
    override func setUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            headerView,
            feelView
        )
        
        switch type {
        case .question:
            guard let thinkView else { return }
            contentView.addSubview(thinkView)
        case .activation:
            guard let actionView else { return }
            contentView.addSubview(actionView)
        }
    }
    
    override func setLayout() {
        let safeArea = safeAreaLayoutGuide
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
            $0.bottom.equalTo(feelView.snp.bottom).offset(24.adjustedH)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(132.adjustedH)
        }
        
        if let thinkView {
            thinkView.snp.makeConstraints {
                $0.top.equalTo(headerView.snp.bottom)
                $0.horizontalEdges.equalToSuperview()
            }
            feelView.snp.makeConstraints {
                $0.top.equalTo(thinkView.snp.bottom)
                $0.horizontalEdges.equalToSuperview()
            }
        }
        
        if let actionView {
            actionView.snp.makeConstraints {
                $0.top.equalTo(headerView.snp.bottom)
                $0.horizontalEdges.equalToSuperview()
            }
            feelView.snp.makeConstraints {
                $0.top.equalTo(actionView.snp.bottom)
                $0.horizontalEdges.equalToSuperview()
            }
        }
    }
}

extension ArchiveQuestView {
    func updateUI(_ entity: QuestAnswerEntity) {
        self.headerView.updateUI(
            stepNumber: entity.stepNumber,
            questNumber: entity.questNumber,
            date: entity.createdAt,
            title: entity.question
        )
        
        self.feelView.updateUI(
            emotionType: entity.questEmotionState,
            descriptionText: entity.emotionDescription
        )
        
        switch self.type {
        case .question:
            self.thinkView?.updateUI(description: entity.answer)
        case .activation:
                self.actionView?.updateUI(description: entity.answer, photoURL: entity.imageUrl!)
            
        }
    }
}
