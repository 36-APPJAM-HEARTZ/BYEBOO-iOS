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
    private(set) var unCompleteListView: JourneyListView
    
    private let unCompleteJourneyList: [JourneyEntity]
    init(
        unCompleteJourneyList: [JourneyEntity]
    ) {
        self.unCompleteJourneyList = unCompleteJourneyList
        unCompleteListView = JourneyListView(isFinished: false, journeyList: [])
        
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
            $0.font = FontManager.body6R14.font
            $0.textColor = .grayscale400
        }
        unCompleteListView.do {
            $0.isUserInteractionEnabled = true
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            descriptionLabel,
            divider1,
            unCompleteListView
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
    }

}


extension NewJourneySelectView {
    func bind(with entity: LookBackJourneyEntity) {
        unCompleteListView.updateUI(journeyList: entity.inCompletedJourneys)
        unCompleteListView.updateCountLabel(count: entity.inCompletedCount)
    }
}
