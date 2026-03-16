//
//  ProgressBarView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/7/25.
//

import UIKit

import SnapKit
import Then

enum ProgressBarType: Int {
    case first, second
    
    var buttonName: String {
        switch self {
        case .first:
            "다음으로"
        case .second:
            "완료하기"
        }
    }
}

final class ProgressBarView: BaseView {
    
    private let progressGroupView = UIView()
    private let firstProgressView = UIProgressView()
    private let secondProgressView = UIProgressView()
    private let progressStackView = UIStackView()
    private lazy var progressViews = [firstProgressView, secondProgressView]
    
    init(type: ProgressBarType) {
        super.init(frame: .zero)
        setProgress(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        progressGroupView.do {
            $0.backgroundColor = .clear
        }
        progressStackView.do {
            $0.axis = .horizontal
            $0.spacing = 7
        }
        progressViews.forEach { setProgressView($0) }
    }
    
    override func setUI() {
        progressStackView.addArrangedSubviews(
            firstProgressView,
            secondProgressView
        )
        progressGroupView.addSubview(progressStackView)
        addSubview(progressGroupView)
    }
    
    override func setLayout() {
        progressGroupView.snp.makeConstraints {
            $0.width.equalTo(375.adjustedW)
        }
        progressStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.top.equalToSuperview().inset(13.adjustedH)
            $0.bottom.equalToSuperview().inset(13.adjustedH)
        }
        firstProgressView.snp.makeConstraints {
            $0.width.equalTo(160.adjustedW)
            $0.height.equalTo(6.adjustedH)
        }
        secondProgressView.snp.makeConstraints {
            $0.width.equalTo(160.adjustedW)
            $0.height.equalTo(6.adjustedH)
        }
    }
    
    private func setProgress(type: ProgressBarType) {
        switch type {
        case .first:
            firstProgressView.progress = 1
            secondProgressView.progress = 0
        case .second:
            firstProgressView.progress = 0
            secondProgressView.progress = 1
        }
    }
    
    private func setProgressView(_ progressView: UIProgressView) {
        progressView.do {
            $0.trackTintColor = .primary30020
            $0.progressTintColor = .primary300
            $0.layer.cornerRadius = 12.adjustedW
        }
    }
}
