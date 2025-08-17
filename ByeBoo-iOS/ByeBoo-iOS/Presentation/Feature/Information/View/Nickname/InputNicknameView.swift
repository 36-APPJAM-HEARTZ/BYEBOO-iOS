//
//  InputNicknameView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/7/25.
//

import UIKit

import SnapKit
import Then

enum NicknameState: String {
    case normal = "2자 이상 · 공백 제외  · 영어 숫자 한글 구성\n"
    case complete = "* 설정 가능한 닉네임이에요!\n"
}

final class InputNicknameView: BaseView {
    
    private let titleView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let nicknameFieldView = UIView()
    private(set) var nicknameTextField = ByeBooNicknameTextField(.onBeginEditing)
    
    private let nicknameStateView = UIView()
    private let errorIconImageView = UIImageView()
    private let nicknameStateLabel = UILabel()
    private let letterCountLabel = UILabel()
    
    override func setStyle() {
        titleView.backgroundColor = .clear
        titleLabel.do {
            $0.text = "닉네임을 입력해주세요"
            $0.textColor = .grayscale50
            $0.textAlignment = .left
            $0.font = FontManager.head1M24.font
        }
        subTitleLabel.do {
            $0.text = "어떤 이름으로 불러드릴까요?"
            $0.textColor = .grayscale400
            $0.textAlignment = .left
            $0.font = FontManager.body6R14.font
        }
        nicknameFieldView.backgroundColor = .clear
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
        nicknameTextField.onTextChange = { [weak self] text in
            self?.letterCountLabel.text = "\(text.count)/\(5)"
        }
        nicknameTextField.onStateChange = { [weak self] type in
            self?.updateNicknameState(type)
        }
    }
    
    override func setUI() {
        titleView.addSubviews(
            titleLabel,
            subTitleLabel
        )
        nicknameFieldView.addSubview(nicknameTextField)
        nicknameStateView.addSubviews(
            errorIconImageView,
            nicknameStateLabel,
            letterCountLabel
        )
        addSubviews(
            titleView,
            nicknameFieldView,
            nicknameStateView
        )
    }
    
    override func setLayout() {
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30.adjustedH)
            $0.width.equalTo(375.adjustedW)
            $0.height.equalTo(98.adjustedH)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15.adjustedH)
            $0.leading.equalToSuperview().offset(25.adjustedW)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(327.adjustedW)
            $0.height.equalTo(31.adjustedH)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9.adjustedH)
            $0.leading.equalToSuperview().offset(25.adjustedW)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(327.adjustedW)
            $0.height.equalTo(18.adjustedH)
        }
        nicknameFieldView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.width.equalTo(375.adjustedW)
            $0.height.equalTo(72.adjustedH)
        }
        nicknameTextField.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(327.adjustedW)
            $0.height.equalTo(56.adjustedH)
        }
        nicknameStateView.snp.makeConstraints {
            $0.top.equalTo(nicknameFieldView.snp.bottom)
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

extension InputNicknameView {
    
    func updateNicknameState(_ type: NicknameFieldType) {
        switch type {
        case .onBeginEditing:
            nicknameStateLabel.text = NicknameState.normal.rawValue
            nicknameStateLabel.textColor = .grayscale400
            letterCountLabel.textColor = .grayscale400
            errorIconImageView.image = .error
            errorIconImageView.isHidden = false
            makeErrorIconImageViewConstraints()
        case .error:
            nicknameStateLabel.text = NicknameState.normal.rawValue
            nicknameStateLabel.textColor = .error300
            letterCountLabel.textColor = .error300
            errorIconImageView.image = .errorRed
            errorIconImageView.isHidden = false
            makeErrorIconImageViewConstraints()
        case .normal:
            nicknameStateLabel.text = NicknameState.complete.rawValue
            nicknameStateLabel.textColor = .primary300
            letterCountLabel.textColor = .primary300
            errorIconImageView.isHidden = true
            errorIconImageView.snp.updateConstraints {
                $0.size.equalTo(0)
            }
        }
    }
    
    private func makeErrorIconImageViewConstraints() {
        errorIconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.top.equalToSuperview().offset(8.adjustedH)
            $0.size.equalTo(16.adjustedW)
        }
    }
}
