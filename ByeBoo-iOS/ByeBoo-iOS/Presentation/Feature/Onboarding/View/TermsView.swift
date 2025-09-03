//
//  TermsView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/18/25.
//

import UIKit

final class TermsView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private let mainTitleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private(set) var allAgreeView = UIView()
    private(set) var allCheckButton = UIButton()
    private let allAgreeLabel = UILabel()
    private(set) var serviceAgreeView = DetailTermsView(title: "서비스 이용약관 동의", isHiddenViewMore: false)
    private(set) var privacyAgreeView = DetailTermsView(title: "개인정보 수집·이용 동의", isHiddenViewMore: false)
    private(set) var ageAgreeView = DetailTermsView(title: "만 14세 이상입니다", isHiddenViewMore: true)
    private(set) var moveNextButton = ByeBooButton(titleText: "다음으로", type: .disabled2)
    
    private var isAllAgreeButtonDidTap: Bool = false
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgNoLight
        }
        mainTitleLabel.do {
            $0.text = "필수 약관에 동의해 주세요"
            $0.textColor = .grayscale50
            $0.font = FontManager.head1M24.font
        }
        subTitleLabel.do {
            $0.text = "Bye Boo 이용을 위해 필요해요"
            $0.textColor = .grayscale400
            $0.font = FontManager.body6R14.font
        }
        allAgreeView.do {
            $0.backgroundColor = .white10
            $0.layer.cornerRadius = 12
        }
        allCheckButton.do {
            $0.setImage(.checkRound, for: .normal)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 9
        }
        allAgreeLabel.do {
            $0.text = "전체 동의"
            $0.textColor = .grayscale300
            $0.font = FontManager.body3R16.font
        }
    }
    
    override func setUI() {
        allAgreeView.addSubviews(
            allCheckButton,
            allAgreeLabel
        )
        addSubviews(
            backgroundImageView,
            mainTitleLabel,
            subTitleLabel,
            allAgreeView,
            serviceAgreeView,
            privacyAgreeView,
            ageAgreeView,
            moveNextButton
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(20.5.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(8.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        allAgreeView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(28.5.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(59.adjustedH)
        }
        allCheckButton.snp.makeConstraints {
            $0.leading.equalTo(allAgreeView.snp.leading).offset(24.adjustedW)
            $0.centerY.equalTo(allAgreeView.snp.centerY)
            $0.size.equalTo(18.adjustedW)
        }
        allAgreeLabel.snp.makeConstraints {
            $0.leading.equalTo(allCheckButton.snp.trailing).offset(8.adjustedW)
            $0.centerY.equalTo(allAgreeView.snp.centerY)
        }
        serviceAgreeView.snp.makeConstraints {
            $0.top.equalTo(allAgreeView.snp.bottom).offset(24.adjustedH)
            $0.leading.trailing.equalToSuperview()
        }
        privacyAgreeView.snp.makeConstraints {
            $0.top.equalTo(serviceAgreeView.snp.bottom).offset(16.adjustedH)
            $0.leading.trailing.equalToSuperview()
        }
        ageAgreeView.snp.makeConstraints {
            $0.top.equalTo(privacyAgreeView.snp.bottom).offset(16.adjustedH)
            $0.leading.trailing.equalToSuperview()
        }
        moveNextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(36.adjustedH)
        }
    }
}

extension TermsView {
    
    private var isAllAgree: Bool {
        serviceAgreeView.isChecked && privacyAgreeView.isChecked && ageAgreeView.isChecked
    }
    
    func toggleAllAgree() {
        isAllAgreeButtonDidTap.toggle()
        updateUI()
        [serviceAgreeView, privacyAgreeView, ageAgreeView].forEach { $0.isChecked = isAllAgreeButtonDidTap }
    }
    
    func updateAllAgreeState() {
        isAllAgreeButtonDidTap = isAllAgree
        updateUI()
    }
    
    private func updateUI() {
        allAgreeView.do {
            $0.backgroundColor = isAllAgreeButtonDidTap ? .primary30020 : .white10
            $0.layer.borderWidth = isAllAgreeButtonDidTap ? 1 : 0
            $0.layer.borderColor = UIColor.primary300.cgColor
        }
        allCheckButton.setImage(isAllAgreeButtonDidTap ? .checkAll : .checkRound, for: .normal)
        allAgreeLabel.textColor = isAllAgreeButtonDidTap ? .primary50 : .grayscale300
        moveNextButton.updateType(isAllAgreeButtonDidTap ? .enabled : .disabled2)
    }
}
