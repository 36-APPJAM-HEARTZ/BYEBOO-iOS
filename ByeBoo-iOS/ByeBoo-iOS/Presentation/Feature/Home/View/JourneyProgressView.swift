//
//  JourneyProgressView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

final class JourneyProgressView: BaseView {

    private let titleLabel = UILabel()
    private let progressStackView = UIStackView()
    private let progressView = UIProgressView()
    private let progressLabel = UILabel()
    
    override func setStyle() {
        backgroundColor = .white10
        layer.cornerRadius = 12
        
        titleLabel.do {
            $0.text = "하츠핑님의 자기 성찰 여정"
            $0.font = FontManager.sub2Sb18.font
            $0.textColor = .grayscale50
        }
        progressStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
        progressView.do {
            $0.progress = 0
            $0.progressTintColor = .primary300
            $0.trackTintColor = .primary30020
            $0.layer.cornerRadius = 12
        }
        progressLabel.do {
            $0.font = FontManager.cap2R12.font
            $0.textColor = .grayscale400
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            progressStackView
        )
        progressStackView.addArrangedSubviews(
            progressView,
            progressLabel
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        progressStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(16.adjustedH)
            $0.height.equalTo(16.adjustedH)
        }
        progressView.snp.makeConstraints {
            $0.width.equalTo(230.adjustedW)
            $0.height.equalTo(6.adjustedH)
        }
        
    }
}

extension JourneyProgressView {
    func updateProgress(_ progress: Int) {
        progressLabel.text = "(\(progress)/30)"
        progressView.progress = Float(progress) / 30
    }
    
    func updateName(_ name: String) {
        titleLabel.text = "\(name)님의 자기 성찰 여정"
    }
}
