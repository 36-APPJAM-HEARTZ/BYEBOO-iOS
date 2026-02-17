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
    private(set) var nicknameStateView = NicknameStateView()
    
    init() {
        super.init(frame: .zero)
        
        setStyle()
        setUI()
        setLayout()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        titleView.backgroundColor = .clear
        
        titleLabel.applyByeBooFont(
            style: .head1M24,
            text: "닉네임을 입력해주세요",
            color: .grayscale50,
            textAlignment: .left
        )
        
        subTitleLabel.applyByeBooFont (
            style: .body6R14,
            text: "어떤 이름으로 불러드릴까요?",
            color: .grayscale400,
            textAlignment: .left
        )
        
        nicknameFieldView.backgroundColor = .clear
    }
    
    override func setUI() {
        titleView.addSubviews(
            titleLabel,
            subTitleLabel
        )
        nicknameFieldView.addSubview(nicknameTextField)
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
    }
    
    private func setAction() {
        nicknameTextField.onStateChange = { [weak self] type in
            self?.nicknameStateView.updateNicknameState(type)
        }
    }
}
