//
//  HomeHeaderView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

final class HomeHeaderView: BaseView {

    private(set) var homeStateView: HomeStateView = HomeStateView(state: .beforeJourneyStart(journey: .stub()))
    
    private let stackView = UIStackView()
    private var journeyProgressView: JourneyProgressView? = nil
    private let textBox: OnboardingTextView = OnboardingTextView(text: "안녕")
    
    private let state: HomeState = .afterJourney
    
    override func setStyle() {
        backgroundColor = .clear
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 16
        }
    }
    
    override func setUI() {
        addSubview(stackView)
    
        stackView.addArrangedSubviews(
            homeStateView,
            textBox
        )
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(72.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview()
        }
    }
}

extension HomeHeaderView {
    func updateTextBox(_ text: String) {
        textBox.updateText(text)
    }
    
    func updateProgress(_ progress: Int) {
        journeyProgressView?.updateProgress(progress)
    }
    
    func updateName(_ name: String) {
        journeyProgressView?.updateName(name)
    }
    
    func updateJourney(_ title: String) {
        journeyProgressView?.updateJourney(title)
    }
    
    func updateState(_ state: HomeState) {
        if state.hasProgress {
            if journeyProgressView == nil {
                journeyProgressView = JourneyProgressView()
            }
            
            stackView.subviews.forEach { stackView.removeArrangedSubview($0) }
            
            guard let journeyProgressView else { return }
            
            stackView.addArrangedSubviews(
                homeStateView,
                journeyProgressView,
                textBox
            )
        }
        
        homeStateView.updateState(state)
    }
}
