//
//  CommonQuestView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/17/26.
//

import UIKit

import SnapKit

final class CommonQuestView: BaseView {
    
    private(set) var commonQuestTableView = UITableView()
    private(set) var headerView = CommonQuestHeaderView()
    
    override func setStyle() {
        commonQuestTableView.do {
            $0.backgroundColor = .grayscale900
            headerView.frame = CGRect(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 152.adjustedH
            )
            $0.tableHeaderView = headerView
            $0.sectionHeaderTopPadding = 0
            $0.separatorStyle = .none
        }
    }
    
    override func setUI() {
        addSubview(commonQuestTableView)
    }
    
    override func setLayout() {
        commonQuestTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
