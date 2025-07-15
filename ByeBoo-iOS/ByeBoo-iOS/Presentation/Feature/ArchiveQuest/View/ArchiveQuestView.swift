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
    private let headerView = ArchiveQuestHeaderView(
        type: .archive,
        stepNumber: 1,
        questNumber: 2,
        date: "2025. 07. 02",
        questTitle: "그 사람이 싫어하기에 내가 포기해야만 했던 일은 무엇일까?"
    )
    private let thinkView: ThinkView?
    private let actionView: ActionView?
    private let feelView = FeelView(emotionType: "자기이해", descriptionText: "오늘은 퀘스트를 통해 스스로에 대해 더 잘 알게 되셨네요! 아주 바람직하게 나아가고 있어요.")
    
    private let type: QuestType
    
    init(type: QuestType) {
        self.type = type
        
        switch type {
        case .question:
            thinkView = ThinkView(descriptionText: "내 X는 질투가 너무 많았다 어쩌구 저쩌구 그래서 동아리를 할 수가 없엇슨... 특히 솝트처럼 합숙하는 동아리는 완전 금지엿슨 ㅠㅠ ")
            actionView = nil
        case .activation:
            thinkView = nil
            actionView = ActionView(descriptionText: "역시 달리니까 상쾌하다.", photoURL: "https://live.staticflickr.com/65535/5134305911_f4541d7629_m.jpg")
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
            addSubview(thinkView)
        case .activation:
            guard let actionView else { return }
            addSubview(actionView)
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
        DispatchQueue.main.async {
            self.headerView.do {
                $0.stepLabel.text = "\(entity.stepNumber)"
                $0.questNumberLabel.text = "\(entity.questNumber)"
                $0.dateLabel.text = entity.createdAt
                $0.questTitleLabel.text = entity.question
            }
            self.feelView.do {
                $0.emotionType = entity.questEmotionState
                $0.descriptionText = entity.emotionDescription
            }
            
            switch self.type {
            case .question:
                self.thinkView?.descriptionText = entity.answer ?? ""
            case .activation:
                self.actionView?.do {
                    $0.descriptionText = entity.answer
                    $0.photoURL = entity.imageUrl ?? ""
                }
            }
        }
    }
}
