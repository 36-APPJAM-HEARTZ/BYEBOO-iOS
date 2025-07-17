//
//  QuestModalView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/6/25.
//

import UIKit

import SnapKit
import Then

final class QuestModalView: BaseView, ModalProtocol {
    let actionButton: ByeBooButton = ByeBooButton(titleText: "진행하기", type: .enabled)
    var dismissButton: ByeBooButton?
    
    private let imageView = UIImageView()
    private let questLabel = UILabel()
    private let titleLabel = UILabel()
    let tipButton = UIButton()
    
    private var questNumber: Int
    private var quest: String
    
    init(questNumber: Int, quest: String) {
        self.questNumber = questNumber
        self.quest = quest
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .grayscale90080
        layer.cornerRadius = 12.adjustedW
        
        imageView.do {
            $0.backgroundColor = .clear
            $0.image = .banner1
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 12.adjustedW
        }
        
        questLabel.do {
            $0.text = "\(questNumber)번째 퀘스트"
            $0.textColor = .grayscale400
            $0.textAlignment = .center
            $0.font = FontManager.body2M16.font
        }
        
        titleLabel.do {
            $0.text = quest
            $0.textColor = .grayscale50
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = FontManager.sub2Sb18.font
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        tipButton.do {
            $0.setTitle("작성 TIP", for: .normal)
            $0.titleLabel?.font = FontManager.body4Sb14.font
            $0.backgroundColor = .clear
            $0.setTitleColor(.grayscale300, for: .normal)
            $0.layer.cornerRadius = 12.adjustedW
            $0.setUnderLine()
        }
    }
    
    override func setUI() {
        addSubviews(
            imageView,
            questLabel,
            titleLabel,
            tipButton,
            actionButton
        )
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(301.adjustedH)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200.adjustedW)
            $0.height.equalTo(58.adjustedH)
        }
        
        questLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(17.5.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200.adjustedW)
            $0.height.equalTo(21.adjustedH)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(questLabel.snp.bottom).offset(8.adjustedH)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(16.adjustedW)
            $0.trailing.lessThanOrEqualToSuperview().inset(16.adjustedW)
        }
        
        tipButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200.adjustedW)
            $0.height.equalTo(18.adjustedH)
        }
        
        actionButton.snp.makeConstraints {
            $0.top.equalTo(tipButton.snp.bottom).offset(17.5.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(titleLabel.snp.width).offset(16.adjustedW)
            $0.height.equalTo(53.adjustedH)
            $0.bottom.equalToSuperview().inset(20.adjustedH)
        }
    }
}
