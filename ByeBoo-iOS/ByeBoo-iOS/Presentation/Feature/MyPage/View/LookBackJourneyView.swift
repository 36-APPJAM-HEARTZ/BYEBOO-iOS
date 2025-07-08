//
//  LookBackJourneyView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

// TODO: 임시 객체 추후 서버 API 확정되면 교체 예정
struct Journey {
    let type: String
    let title: String
    
    static func stub() -> Journey {
        return .init(type: "질문형", title: "감정 직면 여정")
    }
}

final class LookBackJourneyView: BaseView {
    // TODO: 승준이의 attributedString 반영
    private let titleLabel = UILabel()
    private let divider = SectionDividerView()
    private let journeyView: JourneyListView
    
    private let journeyList: [Journey]
    
    init(journeyList: [Journey]) {
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
            $0.font = FontManager.head1Sb24.font
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
