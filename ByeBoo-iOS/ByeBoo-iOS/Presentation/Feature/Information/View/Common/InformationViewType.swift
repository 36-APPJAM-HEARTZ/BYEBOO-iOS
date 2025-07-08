//
//  InformationViewType.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/7/25.
//

enum InformationViewType {
    case inputNickname
    case selectEmotion
    case selectQuest
    
    var view: BaseView {
        switch self {
        case .inputNickname:
            return InputNicknameView()
        case .selectEmotion:
            return SelectEmotionView(emotionCardsView: EmotionCardsView())
        case .selectQuest:
            return SelectQuestView()
        }
    }
}
