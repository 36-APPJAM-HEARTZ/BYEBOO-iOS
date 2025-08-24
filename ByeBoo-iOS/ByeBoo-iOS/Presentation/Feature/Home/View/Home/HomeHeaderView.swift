//
//  HomeHeaderView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

final class HomeHeaderView: BaseView {

    private(set) var homeStateView: HomeStateView = HomeStateView(state: .beforeJourneyStart)
    
    private let stackView = UIStackView()
    private var journeyProgressView: JourneyProgressView? = nil
    private let helperButtonImage = UIImageView()
    let helperButton = UIButton()
    private let helperImageView = UIImageView()
    
    private let state: HomeState = .afterJourney
    
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
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(72.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        helperButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20.5.adjustedH)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
            $0.size.equalTo(36.adjustedW)
        }
        helperImageView.snp.makeConstraints {
            $0.top.equalTo(helperButton.snp.bottom).offset(4.adjustedH)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
        }
    }
}

extension HomeHeaderView {
    func updateProgress(_ progress: Int) {
        journeyProgressView?.updateProgress(progress)
    }
    
    func updateName(_ name: String) {
        journeyProgressView?.updateName(name)
    }
    
    func updateJourney(_ title: String) {
        journeyProgressView?.updateJourney(title)
    }
    
    func updateState(_ state: HomeState, _ journeyTitle: String? = nil) {
        if state.hasProgress {
            if journeyProgressView == nil {
                journeyProgressView = JourneyProgressView()
            }
            
            stackView.subviews.forEach { stackView.removeArrangedSubview($0) }
            
            guard let journeyProgressView else { return }
            
            stackView.addArrangedSubviews(
                homeStateView,
                journeyProgressView
            )
            
            stackView.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(72.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
                $0.bottom.equalToSuperview()
            }
            
            helperButton.alpha = 0
        } else {
            helperButton.alpha = 1
        }
        
        homeStateView.updateState(state, journeyTitle)
    }
    
    func startHelperAnimation() {
        if !state.hasProgress {
            helperImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
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
    
    func helperDidTap() {
        helperImageView.alpha = 0
    }
}
