//
//  HomeHeaderView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

final class HomeHeaderView: BaseView {

    private let stackView = UIStackView()
    private let homeStateView = HomeStateView(state: .beforeJourneyStart(journey: .stub()))
    private let journeyProgressView: JourneyProgressView?
    private let textBox = OnboardingTextView(text: "제가 하츠핑님의 이별 극복을 도와드릴게요.")
    
    private let state: HomeState
    
    init(state: HomeState) {
        self.state = state
        if state.hasProgress {
            journeyProgressView = JourneyProgressView()
        } else{
            journeyProgressView = nil
        }
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .clear
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 16
        }
    }
    
    override func setUI() {
        addSubview(stackView)
    
        if let journeyProgressView {
            stackView.addArrangedSubviews(
                homeStateView,
                journeyProgressView,
                textBox
            )
        } else {
            stackView.addArrangedSubviews(
                homeStateView,
                textBox
            )
        }
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(72.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
    }
}
