//
//  CompletedQuestsHeaderView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 9/1/25.
//

final class CompletedQuestsHeaderView: QuestHeaderBaseView {
    
    override var subtitleText: String {
        "30개의 퀘스트를 돌아보며 성장을 체감할 수 있어요."
    }
    
    override func configure(nickname: String, journey: String, period: String) {
        titleLabel.text = "\(nickname)님의\n\(journey) 여정이에요."
        periodTag.updateText(period)
    }
}
