//
//  HomeStateView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

final class HomeStateView: BaseView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let arrowImageView = UIImageView()
    
    private let state: HomeState
    
    init(state: HomeState) {
        self.state = state
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setStyle() {
        backgroundColor = .white10
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = state.borderColor.cgColor
        
        titleLabel.do {
            $0.text = state.title
            $0.font = FontManager.sub2Sb18.font
            $0.textColor = .grayscale50
        }
        descriptionLabel.do {
            $0.text = state.description
            $0.font = FontManager.body5R14.font
            $0.textColor = .grayscale300
        }
        arrowImageView.do {
            $0.image = .right.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grayscale50
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            descriptionLabel,
            arrowImageView
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(16.adjustedH)
        }
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24.adjustedW)
        }
    }
}

extension HomeStateView {
    func updateState(_ state: HomeState) {
        layer.borderColor = state.borderColor.cgColor
        titleLabel.text = state.title
        descriptionLabel.text = state.description
    }
}
