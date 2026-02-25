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
    
    private let navigationView = UIView()
    private let titleLabel = UILabel()
    private(set) var closeButton = UIButton()
    private let stepStackView = UIStackView()
    private var stepNum: Int = 0
    private let stepLabel = ByeBooTextTag(type: .gray, text: "STEP 0")
    private var questNum: Int = 0
    private let questLabel = UILabel()
    private let title = UILabel()
    
    private let questType: QuestType
    private var tipQuestion: [String] = []
    
    override func setUI() {
        addSubviews(
            navigationView,
            stepStackView,
            title
        )
        navigationView.addSubviews(closeButton, titleLabel)
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
            
            if index != tipQuestion.count - 1 {
                dividerView.snp.makeConstraints {
                    $0.top.equalTo(textView.snp.bottom).offset(24.5.adjustedH)
                    $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
                }
                previousView = dividerView
            }
            
        }
    }
    
    override func setStyle() {
        navigationView.do {
            $0.backgroundColor = .grayscale900
        }
        
        titleLabel.applyByeBooFont (
            style: .sub1Sb20,
            text: "퀘스트 작성 TIP",
            color: .white
        )
        
        closeButton.do {
            let image = UIImage.xicon.withRenderingMode(.alwaysTemplate)
            $0.setImage(image, for: .normal)
            $0.tintColor = .white
        }
        
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
    
    override func setLayout() {
        backgroundColor = .grayscale900
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(24.adjustedH)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(navigationView.snp.center)
        }
        
        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalTo(navigationView.snp.centerY)
            $0.width.height.equalTo(24.adjustedW)
        }
        
        stepStackView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(28.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(stepStackView.snp.bottom).offset(12.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.centerX.equalToSuperview()
        }
    }
}
