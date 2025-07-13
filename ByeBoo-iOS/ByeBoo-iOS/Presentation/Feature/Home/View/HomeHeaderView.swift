//
//  HomeHeaderView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

final class HomeHeaderView: BaseView {

    private let stackView = UIStackView()
    let homeStateView: HomeStateView
    private let journeyProgressView: JourneyProgressView?
    let textBox: OnboardingTextView = OnboardingTextView(text: "dd")
    
    private let state: HomeState
    
    init(
        state: HomeState
    ) {
        self.state = state
        
        if state.hasProgress {
            journeyProgressView = JourneyProgressView()
        } else{
            journeyProgressView = nil
        }
        
        homeStateView = HomeStateView(state: state)
        
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
            $0.bottom.equalToSuperview()
        }
    }
}

extension HomeHeaderView {
    func updateTextBox(_ text: String) {
        textBox.updateText(text)
    }
}
