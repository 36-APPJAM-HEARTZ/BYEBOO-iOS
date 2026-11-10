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
    private var tableViewTopConstraint: Constraint?

    // iPhone Duo 대응: 창이 가장 큰 iPhone 폭(440)보다 넓으면 탭과 타이틀 사이 여백을 더 줌
    // 목록 칸은 세로로 길어서 이 뷰의 크기로는 펼친 상태를 판단할 수 없으므로 창 기준
    override func layoutSubviews() {
        tableViewTopConstraint?.update(inset: (window?.bounds.width ?? 0) > 440 ? 12 : 0)
        super.layoutSubviews()
    }

    override func setStyle() {
        commonQuestTableView.do {
            $0.backgroundColor = .grayscale900
            headerView.frame = CGRect(
                x: 0,
                y: 0,
                width: 375.adjustedW,
                height: 152.adjustedH
            )
            $0.tableHeaderView = headerView
            $0.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 24,
                right: 0
            )
            $0.sectionHeaderTopPadding = 0
            $0.separatorStyle = .none
        }
    }
    
    override func setUI() {
        addSubview(commonQuestTableView)
    }
    
    override func setLayout() {
        commonQuestTableView.snp.makeConstraints {
            tableViewTopConstraint = $0.top.equalToSuperview().constraint
            $0.bottom.equalToSuperview()
            // iPhone Duo 대응: 나의 여정과 같이 가장 큰 iPhone 폭(440)까지만 쓰고 가운데 정렬
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().priority(.high)
            $0.width.lessThanOrEqualTo(440)
        }
    }
}
