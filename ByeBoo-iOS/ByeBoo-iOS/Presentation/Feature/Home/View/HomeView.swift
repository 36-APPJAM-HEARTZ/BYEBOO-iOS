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
    
    override func setStyle() {
        backgroundImageView.do {
            $0.play()
            $0.loopMode = .loop
            $0.contentMode = .scaleAspectFill
        }
    }

    override func setUI() {
        addSubviews(backgroundImageView)
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
