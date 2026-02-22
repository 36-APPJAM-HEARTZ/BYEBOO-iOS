//
//  ArchiveQuestHeaderView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

import SnapKit
import Then

final class ArchiveQuestHeaderView: BaseView {
    
    private let stepStackView = UIStackView()
    private let stepLabel = ByeBooTextTag(type: .gray, text: "STEP 0")
    private let questNumberLabel = UILabel()
    private let dateLabel = UILabel()
    private let qLaebl = UILabel()
    private(set) var questTitleLabel = UILabel()
    
    private let stepNumber: Int
    private let questNumber: Int
    private let date: String
    
    private let questStackView = UIStackView()
    private let questTitle: String
    
    init(
        stepNumber: Int,
        questNumber: Int,
        date: String,
        questTitle: String
    ) {
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
            $0.spacing = 4
        }
        
        questNumberLabel.applyByeBooFont(style: .body6R14, color: .grayscale500)
        dateLabel.applyByeBooFont(style: .body6R14, color: .grayscale500)
        
        questStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4.adjustedW
            $0.alignment = .firstBaseline
        }
        
        qLaebl.applyByeBooFont(
            style: .head2M22,
            text: "Q.",
            color: .primary200
        )
        
        questTitleLabel.do {
            $0.applyByeBooFont (
                style: .head1M24,
                color: .grayscale100,
                numberOfLines: 0
            )
            $0.lineBreakMode = .byWordWrapping
        }
    }
    
    override func setUI() {
        addSubviews(
            stepStackView,
            dateLabel,
            questStackView
        )
        stepStackView.addArrangedSubviews(stepLabel, questNumberLabel)
        questStackView.addArrangedSubviews(qLaebl, questTitleLabel)
    }
    
    override func setLayout() {
        stepStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(stepLabel.snp.bottom).offset(12.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        
        questStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(10.adjustedH)
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
