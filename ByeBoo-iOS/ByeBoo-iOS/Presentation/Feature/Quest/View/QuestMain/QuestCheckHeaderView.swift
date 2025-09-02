//
//  QuestCheckHeaderView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

final class QuestCheckHeaderView: QuestHeaderBaseView {
    
    override var subtitleText: String {
        "오늘도 한 걸음 나아가 볼까요?"
    }
    
    override func configure(nickname: String, journey: String, period: String) {
        titleLabel.text = "\(nickname)님, 지금\n\(journey) 여정을 진행 중이에요"
        periodTag.updateText("\(period)일째")
    }
}
