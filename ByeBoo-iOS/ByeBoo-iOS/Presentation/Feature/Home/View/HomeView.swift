//
//  HomeView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

import Lottie

final class HomeView: BaseView {

    private let backgroundImageView = LottieAnimationView(name: "Bori_home_4")
    private let headerView = HomeHeaderView(state: .beforeQuest)
    
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
