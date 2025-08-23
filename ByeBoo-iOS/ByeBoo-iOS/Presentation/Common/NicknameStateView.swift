//
//  NicknameStateView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/21/25.
//

import UIKit

final class NicknameStateView: BaseView {
    
    private let nicknameStateView = UIView()
    private let errorIconImageView = UIImageView()
    private let nicknameStateLabel = UILabel()
    private(set) var letterCountLabel = UILabel()
    
    override func setStyle() {
        nicknameStateView.backgroundColor = .clear
        nicknameStateLabel.do {
            $0.text = NicknameState.normal.rawValue
            $0.textColor = .grayscale400
            $0.font = FontManager.cap2R12.font
        }
        errorIconImageView.do {
            $0.image = .error
        }
        letterCountLabel.do {
            $0.text = "0/5"
            $0.textColor = .grayscale400
            $0.textAlignment = .right
            $0.font = FontManager.cap2R12.font
        }
    }
    
    override func setUI() {
        addSubviews(
            errorIconImageView,
            nicknameStateLabel,
            letterCountLabel
        )
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(375.adjustedW)
            $0.height.equalTo(48.adjustedH)
        }
        errorIconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.top.equalToSuperview().offset(8.adjustedH)
            $0.size.equalTo(16.adjustedW)
        }
        nicknameStateLabel.snp.makeConstraints {
            $0.leading.equalTo(errorIconImageView.snp.trailing).offset(3.adjustedW)
            $0.top.equalToSuperview().offset(8.adjustedH)
            $0.width.equalTo(300.adjustedW)
            $0.height.equalTo(16.adjustedH)
        }
        letterCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24.adjustedW)
            $0.top.equalToSuperview().offset(8.adjustedH)
            $0.width.equalTo(27.adjustedW)
            $0.height.equalTo(16.adjustedH)
        }
    }
}

extension NicknameStateView {
    
    func updateNicknameState(_ type: NicknameFieldType) {
        switch type {
        case .onBeginEditing: updateOnBeginEditingState()
        case .error: updateErrorState()
        case .normal: updateNormalState()
        }
    }
    
    private func updateOnBeginEditingState() {
        nicknameStateLabel.text = NicknameState.normal.rawValue
        nicknameStateLabel.textColor = .grayscale400
        letterCountLabel.textColor = .grayscale400
        errorIconImageView.image = .error
        errorIconImageView.isHidden = false
        revealErrorIconImageView()
    }
    
    private func updateErrorState() {
        nicknameStateLabel.text = NicknameState.normal.rawValue
        nicknameStateLabel.textColor = .error300
        letterCountLabel.textColor = .error300
        errorIconImageView.image = .errorRed
        errorIconImageView.isHidden = false
        revealErrorIconImageView()
    }
    
    private func updateNormalState() {
        nicknameStateLabel.text = NicknameState.complete.rawValue
        nicknameStateLabel.textColor = .primary300
        letterCountLabel.textColor = .primary300
        errorIconImageView.isHidden = true
        hideErrorIconImageView()
    }
    
    private func revealErrorIconImageView() {
        errorIconImageView.snp.updateConstraints {
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.top.equalToSuperview().offset(8.adjustedH)
            $0.size.equalTo(16.adjustedW)
        }
    }
    
    private func hideErrorIconImageView() {
        errorIconImageView.snp.updateConstraints {
            $0.size.equalTo(0)
        }
    }
}
