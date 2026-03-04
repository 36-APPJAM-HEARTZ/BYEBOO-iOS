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
    private let questScope: QuestScope?
    private var questNum: Int
    private let questNumLabel =  UILabel()
    private let titleLabel = UILabel()
    private(set) var tipTag = ByeBooTipTag(text: "작성 TIP")
    
    init(
        questScope: QuestScope? = nil,
        questNum: Int,
        title: String
    ) {
        self.questScope = questScope
        self.questNum = questNum
        self.titleLabel.text = title
        
        if let questScope {
            switch questScope {
            case .common:
                questNumLabel.text = "공통퀘스트"
            case .personal:
                questNumLabel.text = "\(questNum)번째 퀘스트"
            }
        } else {
            questNumLabel.text = "\(questNum)번째 퀘스트"
        }
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        addSubviews(questNumLabel, titleLabel, tipTag)
    }
    
    override func setStyle() {
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
            if questScope == .common {
                $0.isHidden = true
            } else {
                $0.isHidden = false
            }
        }
        
    }
    
    override func setLayout() {
        questNumLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(questNumLabel.snp.bottom).offset(12.adjustedH)
            $0.width.equalTo(327.adjustedW)
            $0.centerX.equalToSuperview()
            if questScope == .common {
                $0.bottom.equalToSuperview().inset(16.adjustedH)
            }
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
    func bind(questScope: QuestScope?, questNum: Int, title: String) {
        self.questNum = questNum
        self.titleLabel.text = title
        
        if let questScope {
            switch questScope {
            case .common:
                questNumLabel.text = "공통퀘스트"
                tipTag.isHidden = true
                
                titleLabel.snp.makeConstraints {
                    $0.top.equalTo(questNumLabel.snp.bottom).offset(12.adjustedH)
                    $0.width.equalTo(327.adjustedW)
                    $0.centerX.equalToSuperview()
                    $0.bottom.equalToSuperview().inset(16.adjustedH)
                }
            case .personal:
                questNumLabel.text = "\(questNum)번째 퀘스트"
                tipTag.isHidden = false
            }
        }
    }
}
