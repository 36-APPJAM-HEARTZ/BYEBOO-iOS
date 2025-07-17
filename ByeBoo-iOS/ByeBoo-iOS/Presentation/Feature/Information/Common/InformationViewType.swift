//
//  InformationViewType.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/7/25.
//

enum InformationViewType {
    case inputNickname(InputNicknameView)
    case selectEmotion(SelectEmotionView)
    case selectQuest(SelectQuestView)
    
    var view: BaseView {
        switch self {
        case .inputNickname(let view): return view
        case .selectEmotion(let view): return view
        case .selectQuest(let view): return view
        }
    }
}
