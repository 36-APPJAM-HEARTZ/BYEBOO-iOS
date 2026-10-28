//
//  HomeHeaderView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

import SnapKit

final class HomeHeaderView: BaseView {
    
    private(set) var homeStateView: HomeStateView = HomeStateView(state: .beforeJourneyStart)
    
    private let stackView = UIStackView()
    private let helperButtonImage = UIImageView()
    let helperButton = UIButton()
    private(set) var helperImageView = UIImageView()
    
    private let state: HomeState = .afterJourney
    private var stackViewTopConstraint: Constraint?
    
    override func setStyle() {
        backgroundColor = .clear
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 16
        }
        helperButton.do {
            var configuration = UIButton.Configuration.plain()
            configuration.image = .questionMark
            configuration.contentInsets = .zero
            $0.configuration = configuration
            $0.alpha = 0
        }
        helperImageView.do {
            $0.image = .helper
            $0.alpha = 0
        }
    }
    
    override func setUI() {
        addSubviews(
            stackView,
            helperButton,
            helperImageView
        )
        
        stackView.addArrangedSubviews(
            homeStateView
        )
    }
    
    // iPhone Duo 대응: 네비바가 세로 바로 가서 위쪽 safe area가 0이면 기존 디자인 여백(108) 대신 위로 붙임
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        stackViewTopConstraint?.update(inset: safeAreaInsets.top > 0 ? 108 : 20)
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            // 기존 디자인 위치(화면 위에서 72 + 알림 버튼 24 + 12)를 유지하되 네비바 아래로는 들어가지 않음
            self.stackViewTopConstraint = $0.top.equalToSuperview().inset(108).priority(.high).constraint
            $0.top.greaterThanOrEqualTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        helperButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20.5)
            $0.trailing.equalToSuperview().inset(24)
            $0.size.equalTo(36)
        }
        helperImageView.snp.makeConstraints {
            $0.top.equalTo(helperButton.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        self.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(100)
            $0.bottom.equalTo(helperButton.snp.bottom)
        }
    }
}

extension HomeHeaderView {
    func updateState(_ state: HomeState, _ journeyTitle: String? = nil) {
        helperImageView.alpha = 0
        homeStateView.updateState(state, journeyTitle)
        
        if state == .beforeJourneyStart {
            helperButton.alpha = 1
        }
        
        stackView.subviews.dropFirst().forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    func startHelperAnimation() {
        helperImageView.alpha = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }
            
            if !state.hasProgress {
                helperImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                UIView.animate(
                    withDuration: 1,
                    delay: 0.3,
                    usingSpringWithDamping: 0.4,
                    initialSpringVelocity: 0.6
                ) {
                    self.helperImageView.alpha = 1
                    self.helperImageView.transform = .identity
                }
            }
        }
    }
    
    func helperDidTap() {
        helperImageView.alpha = 0
    }
    
}
