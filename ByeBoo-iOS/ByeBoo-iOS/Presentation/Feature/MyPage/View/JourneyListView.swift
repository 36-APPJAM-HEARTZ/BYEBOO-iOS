//
//  JourneyListView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

final class JourneyListView: BaseView {

    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let journeyListView: UIStackView?
    
    private let emptyLabel: UILabel?
    
    private let prepareView = OneLineTextBoxView(title: "")
    private let prepareTitleLabel = UILabel()
    
    private let isFinished: Bool
    private let journeyList: [Journey]
    
    init(
        isFinished: Bool,
        journeyList: [Journey]
    ) {
        self.isFinished = isFinished
        self.journeyList = journeyList
        
        if journeyList.isEmpty {
            emptyLabel = UILabel()
            journeyListView = nil
        } else {
            emptyLabel = nil
            journeyListView = UIStackView()
        }
        
        super.init(frame: .zero)
        
        titleLabel.text = isFinished ? "완료" : "미완료"
        countLabel.text = "\(journeyList.count)개"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        titleLabel.do {
            $0.font = FontManager.cap1M12.font
            $0.textColor = .grayscale300
        }
        countLabel.do {
            $0.font = FontManager.body2M16.font
            $0.textColor = .grayscale500
        }
        journeyListView?.do {
            $0.spacing = 16.adjustedH
            $0.axis = .vertical
        }
        emptyLabel?.do {
            // TODO: 미완료 일 때 text 바뀌어야 하는데 앱잼 내에 구현 X
            $0.text = "아직 완료된 여정이 없어요!"
            $0.font = FontManager.body3R16.font
            $0.textColor = .grayscale300
        }
        prepareTitleLabel.do {
            $0.text = "준비 중"
            $0.font = FontManager.body5R14.font
            $0.textColor = .grayscale600
        }
    }
    
    override func setUI() {
        addSubviews(
            stackView
        )
        stackView.addArrangedSubviews(
            titleLabel,
            countLabel
        )
        
        if let journeyListView {
            addSubview(journeyListView)
            journeyList.forEach { journey in
                // TODO: 칩 컴포넌트 바꾸기
                let journeyView = OneLineTextBoxView(
                    title: journey.title,
                    tagTitle: journey.type,
                    tagType: isFinished ? .gray : .purple,
                    isHighlighted: !isFinished
                )
                journeyListView.addArrangedSubview(journeyView)
            }
            prepareView.addSubview(prepareTitleLabel)
            if !isFinished {
                journeyListView.addArrangedSubview(prepareView)
            }
            
        } else if let emptyLabel {
            addSubview(emptyLabel)
        }
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        
        if let journeyListView {
            journeyListView.snp.makeConstraints {
                $0.top.equalTo(stackView.snp.bottom).offset(16.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
                $0.bottom.equalToSuperview().inset(16.adjustedH)
            }
            prepareView.snp.makeConstraints {
                $0.height.equalTo(62.adjustedH)
            }
            prepareTitleLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
        }
        
        if let emptyLabel {
            emptyLabel.snp.makeConstraints {
                $0.top.equalTo(stackView.snp.bottom).offset(201.adjustedH)
                $0.centerX.equalToSuperview()
            }
        }
    }
}
