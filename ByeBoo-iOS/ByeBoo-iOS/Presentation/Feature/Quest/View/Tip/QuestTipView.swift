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
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stepStackView = UIStackView()
    private var stepNum: Int = 0
    private let stepLabel = ByeBooTextTag(type: .gray, text: "STEP 0")
    private var questNum: Int = 0
    private let questLabel = UILabel()
    private let title = UILabel()
    
    private let questType: QuestType
    private var tipQuestion: [String] = []
    private var stepStackViewTopConstraint: Constraint?
    
    override func setUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            stepStackView,
            title
        )
        stepStackView.addArrangedSubviews(stepLabel, questLabel)
    }
    
    init(questType: QuestType) {
        self.questType = questType
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            questType == .activation ? "이렇게 해보면 좋아요." : "이런 걸 생각해 보며 작성해 주세요.",
            "이 퀘스트가 끝나면 어떤 변화가 생길까요?"
        ]
        
        let tips = entity.tips
        
        tips.enumerated().forEach { index, tip in
            
            guard tips[safe: index] != nil else { return }
            
            let iconType: [IconType] = questType == .activation ? [.write, .action, .change] : [.write, .think, .change]
            
            let iconTitleLabel = IconOneLineTextView(iconType: iconType[index], text: tipQuestion[index])
            let textView = TextBoxView(title: tip.tipAnswer)
            let dividerView = SectionDividerView()
            contentView.addSubviews(iconTitleLabel, textView, dividerView)
            
            iconTitleLabel.snp.makeConstraints {
                let offset = previousView == title ? 36.5.adjustedH : 24.5.adjustedH
                $0.top.equalTo(previousView.snp.bottom).offset(offset)
                $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            }
            
            textView.snp.makeConstraints {
                $0.top.equalTo(iconTitleLabel.snp.bottom).offset(12.adjustedH)
                $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            }
            
            if index != tipQuestion.count - 1 {
                dividerView.snp.makeConstraints {
                    $0.top.equalTo(textView.snp.bottom).offset(24.5.adjustedH)
                    $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
                }
                previousView = dividerView
            }
            
            if index == tips.count - 1 {
                textView.snp.makeConstraints {
                    $0.bottom.equalToSuperview().inset(24.adjustedH)
                }
            }
        }
    }
    
    override func setStyle() {
        stepStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        questLabel.applyByeBooFont(style: .body6R14, color: .grayscale500)
        
        title.do {
            $0.applyByeBooFont(
                style: .head1M24,
                color: .grayscale100,
                textAlignment: .center,
                numberOfLines: 0
            )
            $0.lineBreakMode = .byWordWrapping
        }
    }
    
    // iPhone Duo 대응: 네비바가 세로 바로 가서 위쪽 safe area가 0이면 화면 위에 붙지 않도록 여백을 더 줌
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        stepStackViewTopConstraint?.update(inset: safeAreaInsets.top > 0 ? 8.adjustedH : 24)
    }
    
    override func setLayout() {
        backgroundColor = .grayscale900
        
        // iPhone Duo 대응: 오른쪽 세로 바(네비바, 상태바)와 겹치지 않도록 safe area 기준. 낮은 화면에서는 스크롤
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        stepStackView.snp.makeConstraints {
            stepStackViewTopConstraint = $0.top.equalToSuperview().inset(8.adjustedH).constraint
            $0.centerX.equalToSuperview()
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(stepStackView.snp.bottom).offset(12.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.centerX.equalToSuperview()
        }
    }
}
