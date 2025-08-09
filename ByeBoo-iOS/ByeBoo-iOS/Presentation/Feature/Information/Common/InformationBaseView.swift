//
//  InformationBaseView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/7/25.
//

import UIKit

import SnapKit
import Then

final class InformationBaseView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private var progressBarType: ProgressBarType
    private lazy var progressView = ProgressBarView(type: progressBarType)
    var informationView: BaseView
    private(set) var nextButton = ByeBooButton(titleText: "다음으로", type: .disabled2)
    
    init(informationView: BaseView, progressBarType: ProgressBarType) {
        self.informationView = informationView
        self.progressBarType = progressBarType
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgNoLight
            $0.contentMode = .scaleAspectFill
        }
        
        switch informationView {
        case let view as InputNicknameView: updateNicknameViewNextButton(view: view)
        case let view as SelectEmotionView: updateEmotionViewNextButton(view: view)
        case let view as SelectQuestView: updateQuestViewNextButton(view: view)
        default: break
        }
    }
    
    override func setUI() {
        addSubview(backgroundImageView)
        addSubviews(
            progressView,
            informationView,
            nextButton
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        informationView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.width.equalTo(375.adjustedH)
            $0.height.equalTo(312.adjustedH)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(326.adjustedH)
            $0.height.equalTo(53.adjustedH)
        }
    }
}

extension InformationBaseView {
    
    func replace(informationView: BaseView, progressBarType: ProgressBarType) {
        self.informationView.removeFromSuperview()
        self.progressView.removeFromSuperview()
        
        self.informationView = informationView
        self.progressBarType = progressBarType
        self.progressView = ProgressBarView(type: self.progressBarType)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    private func updateNicknameViewNextButton(view: InputNicknameView) {
        view.nicknameTextField.onRegex = { [weak self] condition in
            if condition {
                self?.nextButton.updateType(.enabled)
                return
            }
            self?.nextButton.updateType(.disabled2)
        }
        
        if let currentText = view.nicknameTextField.nicknameField.text {
            updateButtonWhenBack(condition: currentText.isValidNickname)
        }
    }
    
    private func updateEmotionViewNextButton(view: SelectEmotionView) {
        view.emotionCardsView.emotionCards.forEach {
            $0.onSelected = {
                self.nextButton.updateType(.enabled)
            }
        }
        
        let hasSelected = view.emotionCardsView.emotionCards.contains { $0.isSelected }
        updateButtonWhenBack(condition: hasSelected)
    }
    
    private func updateQuestViewNextButton(view: SelectQuestView) {
        view.questCardsView.questCards.forEach {
            $0.onSelected = {
                self.nextButton.updateType(.enabled)
            }
        }
        
        let hasSelected = view.questCardsView.questCards.contains { $0.isSelected }
        updateButtonWhenBack(condition: hasSelected)
    }
    
    private func updateButtonWhenBack(condition: Bool) {
        if condition {
            self.nextButton.updateType(.enabled)
            return
        }
        self.nextButton.updateType(.disabled2)
    }
}
