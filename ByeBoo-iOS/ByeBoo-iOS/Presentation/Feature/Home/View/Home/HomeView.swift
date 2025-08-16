//
//  HomeView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

import Lottie

final class HomeView: BaseView {

    private let backgroundImageView = LottieAnimationView(name: "Bori_home8")
    private(set) var headerView = HomeHeaderView()
    private let speechBoxView = SpeechTextBoxView(title: "")
    
    override func setStyle() {
        backgroundImageView.do {
            $0.play()
            $0.loopMode = .loop
            $0.contentMode = .scaleAspectFill
        }
    }

    override func setUI() {
        addSubviews(
            backgroundImageView,
            headerView,
            speechBoxView
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(268.adjustedH)
        }
        speechBoxView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(316.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

extension HomeView {
    func updateOnboardingText(_ text: String) {
        speechBoxView.updateText(text)
    }
    
    func updateProgressView(
        name: String,
        progress: Int,
        journey: String
    ) {
        headerView.updateProgress(progress)
        headerView.updateName(name)
        headerView.updateJourney(journey)
    }
    
    func updateState(_ state: HomeState) {
        headerView.updateState(state)
    }
    
    func helperDidTap() {
        headerView.helperDidTap()
    }
}
