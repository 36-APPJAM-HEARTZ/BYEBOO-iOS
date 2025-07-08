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

    private let titleLabel = UILabel()
    private let divider = SectionDividerView()
    private let completeTitleLabel = UILabel()
    private let completeCountLabel = UILabel()
    private let listView = UIStackView()
    
    private var emptyLabel: UILabel?
    
    private let journeyList: [Journey]
    
    init(journeyList: [Journey]) {
        self.journeyList = journeyList
        if journeyList.isEmpty {
            self.emptyLabel = UILabel()
        } else {
            self.emptyLabel = nil
        }
        
        super.init(frame: .zero)
        
        completeCountLabel.text = "\(journeyList.count)개"
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
        completeTitleLabel.do {
            $0.text = "완료"
            $0.font = FontManager.cap1M12.font
            $0.textColor = .grayscale300
        }
        completeCountLabel.do {
            $0.font = FontManager.body2M16.font
            $0.textColor = .grayscale500
        }
        listView.do {
            $0.spacing = 16.adjustedH
            $0.axis = .vertical
        }
        emptyLabel?.do {
            $0.text = "아직 완료된 여정이 없어요!"
            $0.font = FontManager.body3R16.font
            $0.textColor = .grayscale300
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            divider,
            completeTitleLabel,
            completeCountLabel
        )
        
        if let emptyLabel {
            addSubview(emptyLabel)
        } else {
            addSubview(listView)
            journeyList.forEach { journey in
                let journeyView = OneLineTextBoxView(title: journey.title, tagTitle: journey.type, tagType: .gray)
                listView.addArrangedSubview(journeyView)
            }
        }
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
        completeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(29.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        completeCountLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(26.5.adjustedH)
            $0.leading.equalTo(completeTitleLabel.snp.trailing).offset(8.adjustedW)
        }
        
        if let emptyLabel {
            emptyLabel.snp.makeConstraints {
                $0.top.equalTo(completeCountLabel.snp.bottom).offset(201.adjustedH)
                $0.centerX.equalToSuperview()
            }
        } else {
            listView.snp.makeConstraints {
                $0.top.equalTo(completeCountLabel.snp.bottom).offset(16.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            }
        }
    }
}
