//
//  BlockUserListView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/22/26.
//

import UIKit

final class BlockedUserListView: BaseView {
    
    private(set) var userTableView = UITableView()
    private let emptyLabel = UILabel()
    
    override func setStyle() {
        self.do {
            $0.backgroundColor = .grayscale900
        }
        userTableView.do {
            $0.backgroundColor = .grayscale900
            $0.separatorStyle = .none
        }
        emptyLabel.do {
            $0.applyByeBooFont(
                style: .body6R14,
                text: "차단하신 사용자가 없어요",
                color: .grayscale400
            )
            $0.isHidden = true
        }
    }
    
    override func setUI() {
        addSubviews(userTableView, emptyLabel)
    }
    
    override func setLayout() {
        userTableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24.adjustedH)
        }
        emptyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(334.5.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
}

extension BlockedUserListView {
    func updateEmptyLabel() {
        self.emptyLabel.isHidden = false
    }
}
