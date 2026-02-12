//
//  QuestTabBar.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/12/26.
//

import UIKit

final class QuestTabBar: UIStackView {
    
    private let itemViews = QuestTabItem.allCases.map { QuestTabBarItemView(item: $0) }
    
    func setStyle() {
        self.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.distribution = .fillEqually
        }
    }
    
    func setUI() {
        itemViews.forEach { self.addArrangedSubview($0) }
    }
    
    func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(220.adjustedW)
            $0.height.equalTo(28.adjustedH)
            $0.edges.equalToSuperview()
        }
    }
}
