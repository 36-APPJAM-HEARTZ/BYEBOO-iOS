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
    private let stepStackView = UIStackView()
    private let stepLabel = ByeBooTextTag(type: .gray, text: "STEP 0")
    private let questNumberLabel = UILabel()
    private let dateLabel = UILabel()
    private(set) var questTitleLabel = UILabel()
    
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
        
        questNumberLabel.text = "\(questNumber)번째 퀘스트"
        dateLabel.text = date.dateFormat()
        questTitleLabel.text = questTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        stepStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .equalCentering
        }
        
        questNumberLabel.do {
            $0.font = FontManager.body6R14.font
            $0.textColor = .grayscale400
        }
        
        dateLabel.do {
            $0.font = FontManager.body6R14.font
            $0.textColor = .grayscale400
        }
        
        questTitleLabel.do {
            $0.font = FontManager.head1M24.font
            $0.textColor = .grayscale100
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            
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
            stepStackView,
            dateLabel,
            questTitleLabel
        )
        stepStackView.addArrangedSubviews(stepLabel, questNumberLabel)
    }
    
    override func setLayout() {
        stepStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            
            switch type {
            case .complete:
                $0.centerX.equalToSuperview()
            case .archive:
                $0.leading.equalToSuperview().inset(24.adjustedW)
            }
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


extension ArchiveQuestHeaderView {
    func updateUI(stepNumber: Int, questNumber: Int, date: String, title: String ){
        self.stepLabel.updateText("STEP \(stepNumber)")
        self.questNumberLabel.text = "\(questNumber)번째 퀘스트"
        self.dateLabel.text = date.dateFormat()
        self.questTitleLabel.text = title
    }
}
