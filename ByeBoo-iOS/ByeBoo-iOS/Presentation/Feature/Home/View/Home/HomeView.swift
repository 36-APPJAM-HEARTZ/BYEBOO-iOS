//
//  HomeView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

import Lottie

final class HomeView: BaseView {

    private let backgroundImageView = UIImageView()
    private let homeBori = LottieAnimationView(name: "bori_home")
    private(set) var headerView = HomeHeaderView()
    private let speechBoxView = SpeechTextBoxView(title: "")
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgHome
            $0.contentMode = .scaleAspectFill
        }
        
        homeBori.do {
            $0.play()
            $0.loopMode = .loop
        }
    }

    override func setUI() {
        addSubviews(
            backgroundImageView,
            homeBori,
            headerView,
            speechBoxView
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        homeBori.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(40.adjustedW)
            $0.bottom.equalToSuperview().offset(160.adjustedH)
        }
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        speechBoxView.snp.makeConstraints {
            $0.bottom.equalTo(homeBori.snp.top).offset(200.adjustedH)
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
    
    func updateState(_ state: HomeState, _ journeyTitle: String? = nil) {
        headerView.updateState(state, journeyTitle)
    }
    
    func helperDidTap() {
        headerView.helperDidTap()
    }
}
