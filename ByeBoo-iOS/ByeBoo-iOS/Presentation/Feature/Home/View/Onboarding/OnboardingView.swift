//
//  OnboardingView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

import UIKit

final class OnboardingView: BaseView {

    private let backgroundImageView = UIImageView()
    private(set) var headerView = OnboardingHeaderView()
    private let contentView = OnboardingContentView()
    private(set) var nextButton = ByeBooButton(titleText: "다음으로", type: .enabled)
    
    var step: OnboardingStep = .first {
        didSet {
            changeStep()
        }
    }
    
    override func setStyle() {
        backgroundImageView.image = .bgOnboarding
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            contentView,
            nextButton,
            headerView
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-20.adjustedH)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(36.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
    }
}

extension OnboardingView {
    private func changeStep() {
        headerView.step = step
        contentView.step = step
        if step == .third {
            nextButton.updateTitle("시작하기")
        }
    }
}
