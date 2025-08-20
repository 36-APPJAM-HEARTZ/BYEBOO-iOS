//
//  LookBackJourneyView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

final class LookBackJourneyView: BaseView {
    
    private let titleLabel = UILabel()
    private let divider = SectionDividerView()
    private let journeyView: JourneyListView
    
    private var journeyList: [JourneyStyleEntity]
    
    init(journeyList: [JourneyStyleEntity]) {
        self.journeyList = journeyList
        self.journeyView = JourneyListView(isFinished: true, journeyList: journeyList)

        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        titleLabel.do {
            $0.text = "내가 완료한 여정이에요."
            $0.font = FontManager.head1M24.font
            $0.textColor = .grayscale50
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            divider,
            journeyView
        )
    }
    
    override func setLayout() {
        let safeArea = safeAreaLayoutGuide
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).inset(4.5.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        divider.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.5.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        journeyView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

extension LookBackJourneyView {
    func bind(with entity: [JourneyStyleEntity]) {
        journeyList = entity
        journeyView.updateCountLabel(count: entity.count)
        journeyView.updateUI(journeyList: journeyList)
    }
}
