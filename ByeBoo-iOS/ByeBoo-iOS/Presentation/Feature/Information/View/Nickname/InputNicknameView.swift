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
    case normal = "* 공백 없이 영어, 숫자와 한글로 구성\n* 2자 이상 5자 이하"
    case complete = "* 설정 가능한 닉네임이에요!\n"
}

final class InputNicknameView: BaseView {
    
    private let titleView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let nicknameFieldView = UIView()
    let nicknameTextField = ByeBooNicknameTextField(.onBeginEditing)
    
    private let nicknameStateView = UIView()
    private let nicknameStateLabel = UILabel()
    private let letterCountLabel = UILabel()
        
    override func setStyle() {
        titleView.backgroundColor = .clear
        
        titleLabel.do {
            $0.attributedText = "닉네임을 입력해주세요".makeTitle(rangedText: "닉네임")
            $0.textAlignment = .left
            $0.font = FontManager.head1Sb24.font
        }
        
        subTitleLabel.do {
            $0.text = "어떤 이름으로 불러드릴까요?"
            $0.textColor = .grayscale400
            $0.textAlignment = .left
            $0.font = FontManager.body5R14.font
        }
        
        nicknameFieldView.backgroundColor = .clear
        
        nicknameStateView.backgroundColor = .clear
        nicknameStateLabel.do {
            $0.text = NicknameState.normal.rawValue
            $0.numberOfLines = 2
            $0.textColor = .grayscale400
            $0.font = FontManager.cap2R12.font
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
        titleView.addSubviews(titleLabel, subTitleLabel)
        nicknameFieldView.addSubview(nicknameTextField)
        nicknameStateView.addSubviews(nicknameStateLabel, letterCountLabel)
        addSubviews(titleView, nicknameFieldView, nicknameStateView)
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
        
        nicknameStateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(300.adjustedW)
            $0.height.equalTo(32.adjustedH)
        }
        
        letterCountLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameStateLabel.snp.trailing)
            $0.top.equalToSuperview().offset(8.adjustedH)
            $0.width.equalTo(27.adjustedW)
            $0.height.equalTo(16.adjustedH)
        }
    }
    
    func updateNicknameState(_ type: NicknameFieldType) {
        switch type {
        case .onBeginEditing:
            nicknameStateLabel.text = NicknameState.normal.rawValue
            nicknameStateLabel.textColor = .grayscale400
            letterCountLabel.textColor = .grayscale400
        case .error:
            nicknameStateLabel.text = NicknameState.normal.rawValue
            nicknameStateLabel.textColor = .error300
            letterCountLabel.textColor = .error300
        case .normal:
            nicknameStateLabel.text = NicknameState.complete.rawValue
            nicknameStateLabel.textColor = .primary300
            letterCountLabel.textColor = .grayscale400
        }
    }
}
