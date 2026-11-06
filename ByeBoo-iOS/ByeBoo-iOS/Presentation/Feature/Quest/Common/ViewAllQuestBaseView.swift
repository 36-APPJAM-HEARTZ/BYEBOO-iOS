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
        // iPhone Duo 대응: 넓은 화면에서 칸이 너무 커지지 않도록 가장 큰 iPhone 폭(440)까지만 쓰고 가운데 정렬
        questCheckHeaderView.snp.makeConstraints {
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.width.equalTo(safeAreaLayoutGuide).priority(.high)
            $0.width.lessThanOrEqualTo(440)
            if questCheckHeaderView is QuestCheckHeaderView {
                $0.top.equalToSuperview()
                return
            }
            $0.top.equalToSuperview().inset(24.adjustedH)
        }
        questCollectionView.snp.makeConstraints {
            $0.top.equalTo(questCheckHeaderView.snp.bottom)
            $0.horizontalEdges.equalTo(questCheckHeaderView)
            $0.bottom.equalToSuperview()
        }
    }
}
