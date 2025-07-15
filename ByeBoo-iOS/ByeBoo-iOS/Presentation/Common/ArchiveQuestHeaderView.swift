//
//  ArchiveQuestHeaderView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

import SnapKit
import Then

enum QuestHeaderType {
    case complete
    case archive
}

final class ArchiveQuestHeaderView: BaseView {

    private let type: QuestHeaderType
    let stepLabel = UILabel()
    let questNumberLabel = UILabel()
    let dateLabel = UILabel()
    let questTitleLabel = UILabel()
    
    private let stepNumber: Int
    private let questNumber: Int
    private let date: String
    private let questTitle: String
    
    init(
        type: QuestHeaderType,
        stepNumber: Int,
        questNumber: Int,
        date: String,
        questTitle: String
    ) {
        self.type = type
        self.stepNumber = stepNumber
        self.questNumber = questNumber
        self.date = date
        self.questTitle = questTitle
        
        super.init(frame: .zero)
        
        stepLabel.text = "STEP \(stepNumber)"
        questNumberLabel.text = "\(questNumber) 번째 퀘스트"
        dateLabel.text = date
        questTitleLabel.text = questTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        stepLabel.do {
            $0.font = FontManager.cap1M12.font
            $0.textColor = .secondary300
        }
        
        questNumberLabel.do {
            $0.font = FontManager.body5R14.font
            $0.textColor = .grayscale400
        }
        
        dateLabel.do {
            $0.font = FontManager.body5R14.font
            $0.textColor = .grayscale400
        }
        
        questTitleLabel.do {
            $0.font = FontManager.head1Sb24.font
            $0.textColor = .grayscale100
            $0.numberOfLines = 0
            
            switch type {
            case .complete:
                $0.textAlignment = .center
            case .archive:
                $0.textAlignment = .left
            }
        }
    }
    
    override func setUI() {
        addSubviews(
            stepLabel,
            questNumberLabel,
            dateLabel,
            questTitleLabel
        )
    }
    
    override func setLayout() {
        stepLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            
            
            switch type {
            case .complete:
                $0.leading.equalToSuperview().inset(118.adjustedW)
            case .archive:
                $0.leading.equalToSuperview().inset(24.adjustedW)
            }
        }
        
        questNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(stepLabel.snp.trailing).offset(8.adjustedW)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(stepLabel.snp.bottom).offset(12.adjustedH)
            
            switch type {
            case .complete:
                $0.centerX.equalToSuperview()
            case .archive:
                $0.leading.equalToSuperview().inset(24.adjustedW)
            }
        }
        
        questTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(9.6.adjustedH)
        }
    }
}
