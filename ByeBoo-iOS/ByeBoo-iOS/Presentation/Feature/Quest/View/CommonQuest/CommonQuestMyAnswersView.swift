//
//  CommonQuestMyAnswersView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import UIKit

final class CommonQuestMyAnswersView: BaseView {
    
    private let myAnswerGuideLabel = UILabel()
    private(set) var answersTableView = UITableView()
    
    override func setStyle() {
        myAnswerGuideLabel.applyByeBooFont(
            style: .head2M22,
            color: .grayscale50,
            numberOfLines: 2
        )
        answersTableView.do {
            $0.backgroundColor = .grayscale900
            $0.separatorStyle = .none
        }
    }
    
    override func setUI() {
        addSubviews(
            myAnswerGuideLabel,
            answersTableView
        )
    }
    
    override func setLayout() {
        myAnswerGuideLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(26.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        answersTableView.snp.makeConstraints {
            $0.top.equalTo(myAnswerGuideLabel.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(24.adjustedH)
        }
    }
}

extension CommonQuestMyAnswersView {
    
    func configure(userName: String) {
        myAnswerGuideLabel.text = "\(userName)님의\n공통 퀘스트 답변이에요"
    }
}
