//
//  WriteQuestTypeView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/7/25.
//

import UIKit

import SnapKit
import Then

final class WriteQuestTitleView: BaseView {
    private let stepStackView = UIStackView()
    private let stepNum = ByeBooTextTag(type: .gray, text: "STEP 0")
    private let stepTitle = UILabel()
    
    private var questNum: Int
    private let questNumLabel =  UILabel()
    
    private let titleLabel = UILabel()
    let tipTag = ByeBooTipTag(text: "작성 TIP")
    
        
    init(stepNum: String, stepTitle: String, questNum: Int, title: String) {
        self.stepTitle.text = stepTitle
        self.questNum = questNum
        self.titleLabel.text = title
        self.questNumLabel.text = "\(questNum)번째 퀘스트"
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setUI() {
        addSubviews(stepStackView, questNumLabel, titleLabel, tipTag)
        stepStackView.addArrangedSubviews(stepNum, stepTitle)
    }
    
    override func setStyle() {
        stepStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8.adjustedW
        }
                
        stepTitle.applyByeBooFont(style: .body2M16, color: .grayscale500)
        questNumLabel.applyByeBooFont(style: .body6R14, color: .grayscale500)
        
        titleLabel.do {
            $0.applyByeBooFont(
                style: .head1M24,
                color: .white,
                textAlignment: .center,
                numberOfLines: 0
            )
            $0.lineBreakMode = .byWordWrapping
        }
        
        tipTag.do {
            $0.isUserInteractionEnabled = true
        }
    }
    
    override func setLayout() {
        stepStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        questNumLabel.snp.makeConstraints {
            $0.top.equalTo(stepStackView.snp.bottom).offset(12.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(questNumLabel.snp.bottom).offset(12.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        tipTag.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
            $0.width.equalTo(76.adjustedW)
            $0.height.equalTo(24.adjustedH)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16.adjustedH)
        }
    }
}

extension WriteQuestTitleView {
    func bind(stepNum: String, stepTitle: String, questNum: Int, title: String) {
        self.stepNum.updateText("STEP \(stepNum)")
        self.stepTitle.text = stepTitle
        self.questNum = questNum
        self.titleLabel.text = title
        questNumLabel.text = "\(questNum)번째 퀘스트"
       }
}
