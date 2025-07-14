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
    let headerView = HomeHeaderView()
    
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
    }
}

extension HomeView {
    func updateOnboardingText(_ text: String) {
        headerView.updateTextBox(text)
    }
    
    func updateProgress(_ progress: Int) {
        headerView.updateProgress(progress)
    }
    
    func updateName(_ name: String) {
        headerView.updateName(name)
    }
    
    func updateState(_ state: HomeState) {
        headerView.updateState(state)
    }
}
