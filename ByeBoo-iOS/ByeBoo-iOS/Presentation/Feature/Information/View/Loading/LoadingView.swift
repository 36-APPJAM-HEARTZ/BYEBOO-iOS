//
//  LoadingView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/9/25.
//

import UIKit

import SnapKit
import Then

final class LoadingView: BaseView {
    
    private let nickname: String
    
    private let loadingStackView = UIStackView()
    private let lottie = UIImageView()
    private let titleLabel = UILabel()
    
    init(nickname: String) {
        self.nickname = nickname
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        loadingStackView.do {
            $0.axis = .vertical
            $0.spacing = 35
        }
        titleLabel.do {
            $0.font = FontManager.body3R16.font
            $0.attributedText = "\(nickname)님에게 꼭 맞는\n이별 극복 여정을 찾는 중 ..."
                .makeTitle(rangedText: nickname, font: FontManager.body1Sb16.font)
            $0.numberOfLines = 2
        }
    }
    
    override func setUI() {
        loadingStackView.addArrangedSubviews(lottie, titleLabel)
        addSubviews(loadingStackView)
    }
    
    override func setLayout() {
        loadingStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(168.adjustedW)
            $0.height.equalTo(96.adjustedH)
        }
        lottie.snp.makeConstraints {
            $0.width.equalTo(76.68.adjustedW)
            $0.height.equalTo(19.adjustedH)
        }
    }
}
