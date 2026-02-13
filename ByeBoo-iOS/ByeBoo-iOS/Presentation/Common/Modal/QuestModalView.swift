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
    var modalType: ConfirmModalType? = nil
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
        self.do {
            $0.backgroundColor = .grayscale900
            $0.layer.cornerRadius = 12.adjustedW
        }
        
        imageView.do {
            $0.backgroundColor = .clear
            $0.image = .banner1
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 12.adjustedW
        }
        
        questLabel.applyByeBooFont(
            style: .body3R16,
            text: "\(questNumber)번째 퀘스트",
            color: .grayscale400,
            textAlignment: .center
        )
        
        
        titleLabel.applyByeBooFont(
            style: .sub3M18,
            text: quest,
            color: .grayscale50,
            textAlignment: .center,
            numberOfLines: 0
        )
        titleLabel.lineBreakMode = .byWordWrapping
        
        tipButton.applyByeBooFont(
            style: .body6R14,
            text: "작성 TIP",
            color: .grayscale300
        )
        tipButton.do {
            $0.backgroundColor = .clear
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
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
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
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(53.adjustedH)
            $0.bottom.equalToSuperview().inset(24.adjustedH)
        }
    }
}
