//
//  ViewAllQuestBaseView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 9/1/25.
//

import UIKit

import SnapKit
import Then

final class ViewAllQuestBaseView: BaseView {
    
    private(set) var questCheckHeaderView: QuestHeaderBaseView
    private(set) var questCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CollectionViewFactory.createLayout()
    )
    
    init(headerView: QuestHeaderBaseView) {
        self.questCheckHeaderView = headerView
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        addSubviews(
            questCheckHeaderView,
            questCollectionView
        )
    }
    
    override func setLayout() {
        questCheckHeaderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            if let questCheckHeaderView = questCheckHeaderView as? QuestCheckHeaderView {
                $0.top.equalToSuperview()
                return
            }
            $0.top.equalToSuperview().inset(24.adjustedH)
        }
        questCollectionView.snp.makeConstraints {
            $0.top.equalTo(questCheckHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
