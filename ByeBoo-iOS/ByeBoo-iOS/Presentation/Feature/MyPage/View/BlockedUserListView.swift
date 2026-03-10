//
//  BlockUserListView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/22/26.
//

import UIKit

final class BlockedUserListView: BaseView {
    
    private(set) var userTableView = UITableView()
    
    override func setStyle() {
        self.do {
            $0.backgroundColor = .grayscale900
        }
        userTableView.do {
            $0.backgroundColor = .grayscale900
            $0.separatorStyle = .none
        }
    }
    
    override func setUI() {
        addSubview(userTableView)
    }
    
    override func setLayout() {
        userTableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24.adjustedH)
        }
    }
}
