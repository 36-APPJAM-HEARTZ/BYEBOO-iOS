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
    
    let questCheckHeaderView = QuestCheckHeaderView()
    let questCollectionView = UICollectionView(
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
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(129.adjustedH)
        }
        questCollectionView.snp.makeConstraints {
            $0.top.equalTo(questCheckHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
