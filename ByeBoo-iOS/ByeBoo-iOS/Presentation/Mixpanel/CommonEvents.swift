//
//  CommonEvents.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 9/16/25.
//

import Mixpanel

struct CommonEvents {
    enum Name {
        static let login = "login"
        static let nicknameComplete = "nickname_complete"
        static let currentEmotionComplete = "current_emotion_complete"
        static let questTypeComplete = "quest_type_complete"
        static let journeyCardComplete = "journey_card_complete"
        static let onboardingComplete = "onboarding_complete"
    }
}

extension CommonEvents {
    struct LoginProperty: MixpanelProperty {
        let isLoginComplete: Bool
        let logintype: String
        
        var dictionary: [String : MixpanelType] {
            [
                "is_login_complete": isLoginComplete,
                "login_type": logintype
            ]
        }
    }
    
    struct SelectQuestTypeProperty: MixpanelProperty {
        let questType: String
        
        var dictionary: [String : any MixpanelType] {
            ["quest_type": questType]
        }
    }
    
    struct JourneyTypeProperty: MixpanelProperty {
        let journeyType: String
        
        var dictionary: [String : any MixpanelType] {
            ["journey_type": journeyType]
        }
    }
}
