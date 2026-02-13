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
        backgroundColor = .white5
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = state.borderColor.cgColor
        
        titleLabel.applyByeBooFont(
            style: FontManager.sub2Sb18,
            text: state.title,
            color: .grayscale50
        )
        
        descriptionLabel.applyByeBooFont(
            style: FontManager.body6R14,
            text: state.description,
            color: .grayscale300
        )
        
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
    func updateState(_ state: HomeState, _ journeyTitle: String? = nil) {
        layer.borderColor = state.borderColor.cgColor
        if let titleText = journeyTitle {
            titleLabel.text = titleText + " " + state.title
        } else {
            titleLabel.text = state.title
        }
        
        descriptionLabel.text = state.description
    }
}
