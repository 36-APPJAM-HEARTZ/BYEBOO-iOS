//
//  HomeView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

import Lottie
import SnapKit

final class HomeView: BaseView {

    private let backgroundImageView = UIImageView()
    private(set) var homeBori = LottieAnimationView(name: "bori_home")
    private(set) var headerView = HomeHeaderView()
    private let speechBoxView = SpeechTextBoxView(title: "")
    
    // iPhone Duo 대응
    // - 가로가 더 넓은 화면(펼친 Duo 내부 디스플레이)에서는 접히는 선(화면 가운데)을 기준으로
    //   왼쪽에 헤더, 오른쪽에 말풍선과 보리를 둠
    // - 그 외에는 기존 배치. 배경은 두 배치 모두 화면 전체에 한 장
    private let leadingPaneGuide = UILayoutGuide()
    private let trailingPaneGuide = UILayoutGuide()
    private var compactConstraints: [Constraint] = []
    private var wideConstraints: [Constraint] = []
    private var isWideLayout: Bool?
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgHome
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        homeBori.do {
            $0.play()
            $0.loopMode = .loop
            // 공간이 모자라면 헤더 카드, 말풍선보다 보리가 먼저 줄어들도록 함
            $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }

    override func setUI() {
        addSubviews(
            backgroundImageView,
            homeBori,
            headerView,
            speechBoxView
        )
        addLayoutGuide(leadingPaneGuide)
        addLayoutGuide(trailingPaneGuide)
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        leadingPaneGuide.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(safeAreaLayoutGuide)
            $0.trailing.equalTo(snp.centerX)
        }
        trailingPaneGuide.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(snp.centerX)
            $0.trailing.equalTo(safeAreaLayoutGuide)
        }
        homeBori.snp.makeConstraints {
            // 높이가 낮은 화면(접은 Duo 외부 디스플레이)에서는 말풍선이 헤더와 겹치지 않도록 비율을 유지한 채 줄어듦
            $0.width.equalTo(homeBori.snp.height).multipliedBy(295.0 / 337.0)
            $0.height.lessThanOrEqualTo(337)
            $0.height.equalTo(337).priority(.medium)
            $0.bottom.equalToSuperview().inset(31)
        }
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
        }
        speechBoxView.snp.makeConstraints {
            $0.bottom.equalTo(homeBori.snp.top).offset(-40)
        }
        
        // 세로로 긴 큰 화면(펼친 Duo를 세로로 돌린 경우)에서도 iPhone처럼 보이도록 헤더 폭은 가장 큰 iPhone(440)까지만
        compactConstraints = homeBori.snp.prepareConstraints {
            $0.centerX.equalTo(safeAreaLayoutGuide)
        } + headerView.snp.prepareConstraints {
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.width.equalTo(safeAreaLayoutGuide).priority(.high)
            $0.width.lessThanOrEqualTo(440)
        } + speechBoxView.snp.prepareConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.top.greaterThanOrEqualTo(headerView.helperImageView.snp.bottom).offset(8)
        }
        wideConstraints = homeBori.snp.prepareConstraints {
            $0.centerX.equalTo(trailingPaneGuide)
        } + headerView.snp.prepareConstraints {
            $0.horizontalEdges.equalTo(leadingPaneGuide)
        } + speechBoxView.snp.prepareConstraints {
            $0.horizontalEdges.equalTo(trailingPaneGuide)
        }
    }
    
    // 접고 펴거나 돌려서 화면 비율이 바뀌면 배치를 바꿈
    override func layoutSubviews() {
        let isWideLayout = bounds.width > bounds.height
        if isWideLayout != self.isWideLayout {
            self.isWideLayout = isWideLayout
            (isWideLayout ? compactConstraints : wideConstraints).forEach { $0.deactivate() }
            (isWideLayout ? wideConstraints : compactConstraints).forEach { $0.activate() }
        }
        super.layoutSubviews()
    }
}

extension HomeView {
    func updateOnboardingText(_ text: String, withAnimation: Bool = false) {
        speechBoxView.updateText(text, withAnimation: withAnimation)
    }
    
    func updateState(_ state: HomeState, _ journeyTitle: String? = nil) {
        headerView.updateState(state, journeyTitle)
    }
    
    func helperDidTap() {
        headerView.helperDidTap()
    }
}
