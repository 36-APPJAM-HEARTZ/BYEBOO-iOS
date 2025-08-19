//
//  DetailAgreeView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/18/25.
//

import UIKit

final class DetailAgreeView: BaseView {
    
    private(set) var checkButton = UIButton()
    private let contentLabel = UILabel()
    private(set) var viewMoreButton = UIButton()
    
    var isChecked: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    init(title: String, isHiddenViewMore: Bool) {
        self.contentLabel.text = "(필수) \(title)"
        self.viewMoreButton.isHidden = isHiddenViewMore
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        checkButton.do {
            $0.setImage(.checkOff.withTintColor(.grayscale400), for: .normal)
            $0.backgroundColor = .clear
        }
        contentLabel.do {
            $0.textColor = .grayscale400
            $0.font = FontManager.cap2R12.font
        }
        viewMoreButton.do {
            $0.setTitle("더보기", for: .normal)
            $0.setTitleColor(.grayscale400, for: .normal)
            $0.titleLabel?.font = FontManager.cap2R12.font
            $0.setUnderLine()
        }
    }
    
    override func setUI() {
        addSubviews(
            checkButton,
            contentLabel,
            viewMoreButton
        )
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(16.adjustedH)
        }
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(39.5.adjustedW)
            $0.size.equalTo(12.adjustedW)
        }
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButton.snp.trailing).offset(16.adjustedW)
            $0.centerY.equalTo(checkButton.snp.centerY)
        }
        viewMoreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(39.5.adjustedW)
            $0.centerY.equalTo(checkButton.snp.centerY)
        }
    }
}

extension DetailAgreeView {
    
    private func updateUI() {
        checkButton.setImage(
            .checkOff.withTintColor(isChecked ? .grayscale50 : .grayscale400),
            for: .normal
        )
        contentLabel.textColor = isChecked ? .grayscale50 : .grayscale400
        viewMoreButton.setTitleColor(isChecked ? .grayscale50 : .grayscale400, for: .normal)
    }
}
