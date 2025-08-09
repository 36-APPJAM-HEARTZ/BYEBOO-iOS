//
//  QuestCheckView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/11/25.
//

import UIKit

import SnapKit
import Then

final class QuestsCheckView: BaseView {
    
    private(set) var questCheckHeaderView = QuestCheckHeaderView()
    private(set) var questCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CollectionViewFactory.createLayout()
    )
    
    override func setUI() {
        addSubviews(
            questCheckHeaderView,
            questCollectionView
        )
    }
    
    override func setLayout() {
        questCheckHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        questCollectionView.snp.makeConstraints {
            $0.top.equalTo(questCheckHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
