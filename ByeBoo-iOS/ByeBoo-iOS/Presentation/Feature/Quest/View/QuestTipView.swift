//
//  QuestTipView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import UIKit

import SnapKit
import Then

final class QuestTipView: BaseView {

    private let stepStackView = UIStackView()
    private var stepNum: Int = 0
    private let stepLabel = ByeBooYellowTag(text: "STEP 0")
    private var questNum: Int = 0
    private let questLabel = UILabel()
    private let title = UILabel()
    
    private var tipQuestion: [String] = []
    
    override func setUI() {
        addSubviews(
            stepStackView,
            title
        )
        
        stepStackView.addArrangedSubviews(stepLabel, questLabel)
    }
    
    func bind(with entity: QuestTipDataEntity) {
        self.stepNum = entity.stepNumber
        stepLabel.updateText("STEP \(stepNum)")
        self.questNum = entity.questNumber
        questLabel.text = "\(questNum)번째 퀘스트"
        self.title.text = entity.question
        var previousView: UIView = title
        tipQuestion = [
            "\(questNum)번째 퀘스트로 드리는 이유",
            "이런 걸 생각해보며 작성해 주세요.",
            "이 퀘스트가 끝나면 어떤 변화가 생길까요?"
        ]
        
        entity.tips.enumerated().forEach { index, tip in
            let iconType: IconType = {
                switch index {
                case 0: return .write
                case 1: return .think
                case 2: return .change
                default: return .write
                }
            }()
            
            let iconTitleLabel = IconOneLineTextView(iconType: iconType, text: tipQuestion[index])
            let textView = TextBoxView(title: tip.tipAnswer)
            let dividerView = SectionDividerView()
            self.addSubviews(iconTitleLabel, textView, dividerView)
            
            iconTitleLabel.snp.makeConstraints {
                let offset = previousView == title ? 36.5.adjustedH : 24.5.adjustedH
                $0.top.equalTo(previousView.snp.bottom).offset(offset)
                $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            }
            
            textView.snp.makeConstraints {
                $0.top.equalTo(iconTitleLabel.snp.bottom).offset(12.adjustedH)
                $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            }
            
            dividerView.snp.makeConstraints {
                $0.top.equalTo(textView.snp.bottom).offset(24.5.adjustedH)
                $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            }
            
            previousView = dividerView
        }
    }
    
    override func setStyle() {
        stepStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        questLabel.do {
            $0.font = FontManager.body5R14.font
            $0.textColor = .grayscale300
        }
        
        title.do {
            $0.font = FontManager.head1Sb24.font
            $0.textColor = .grayscale100
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }
    
    override func setLayout() {
        backgroundColor = .grayscale900
        
        stepStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(stepStackView.snp.bottom).offset(12.adjustedH)
            $0.width.equalTo(327.adjustedW)
            $0.centerX.equalToSuperview()
        }
    }
}
