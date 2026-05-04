//
//  NoticeCardsView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 5/1/26.
//

import UIKit

final class NoticeCardsView: BaseView {
    
    private(set) var cardTableView = UITableView()
    
    override func setStyle() {
        cardTableView.do {
            $0.backgroundColor = .grayscale900
            $0.separatorStyle = .none
            $0.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 24,
                right: 0
            )
        }
    }
    
    override func setUI() {
        addSubview(cardTableView)
    }
    
    override func setLayout() {
        cardTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(80.adjustedH)
        }
    }
}
