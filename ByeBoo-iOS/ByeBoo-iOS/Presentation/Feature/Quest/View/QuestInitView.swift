//
//  QuestInitView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

final class QuestInitView: BaseView {
    
    private let startCardView = QuestSelectCard(type: .start)
    private let lookBackCardView = QuestSelectCard(type: .lookBack)
    
    override func setStyle() {
        backgroundColor = .grayscale900
    }
    
    override func setUI() {
        addSubviews(startCardView, lookBackCardView)
    }
    
    override func setLayout() {
        let safeArea = safeAreaLayoutGuide
        
        startCardView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        lookBackCardView.snp.makeConstraints {
            $0.top.equalTo(startCardView.snp.bottom).offset(40.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
    }

}
