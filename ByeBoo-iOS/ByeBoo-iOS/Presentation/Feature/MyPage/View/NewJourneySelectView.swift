//
//  NewJourneySelectView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

final class NewJourneySelectView: BaseView {
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let divider1 = SectionDividerView()
    private let unCompleteListView: JourneyListView
    private let divider2 = SectionDividerView()
    private let completeListView: JourneyListView
    
    private let unCompleteJourneyList: [JourneyEntity]
    private let completeJourneyList: [JourneyEntity]
    
    init(
        unCompleteJourneyList: [JourneyEntity],
        completeJourneyList: [JourneyEntity]
    ) {
        self.unCompleteJourneyList = unCompleteJourneyList
        self.completeJourneyList = completeJourneyList
        
        unCompleteListView = JourneyListView(isFinished: false, journeyList: unCompleteJourneyList)
        completeListView = JourneyListView(isFinished: true, journeyList: completeJourneyList)
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        titleLabel.do {
            $0.text = "어떤 여정을 시작해볼까요?"
            $0.font = FontManager.head1M24.font
            $0.textColor = .grayscale50
        }
        descriptionLabel.do {
            $0.text = "각 여정 당 30개의 퀘스트를 제공해드려요"
            $0.font = FontManager.body5R14.font
            $0.textColor = .grayscale400
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            descriptionLabel,
            divider1,
            unCompleteListView,
            divider2,
            completeListView
        )
    }
    
    override func setLayout() {
        let safeArea = safeAreaLayoutGuide
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(3.5.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedH)
        }
        divider1.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(11.5.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        unCompleteListView.snp.makeConstraints {
            $0.top.equalTo(divider1.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        divider2.snp.makeConstraints {
            $0.top.equalTo(unCompleteListView.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        completeListView.snp.makeConstraints {
            $0.top.equalTo(divider2.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
    }

}
