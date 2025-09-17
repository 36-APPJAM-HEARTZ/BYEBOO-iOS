//
//  UserEvents.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 9/17/25.
//

import Mixpanel

struct UserEvents {
    struct CurrentEmotionProperty: MixpanelProperty {
        let currentEmotion: String
        
        var dictionary: [String : MixpanelType] {
            ["current_emotion": currentEmotion]
        }
    }
    
    struct UserFirstJourneyTypeProperty: MixpanelProperty {
        let userFirstJourneyType: String
        
        var dictionary: [String : MixpanelType] {
            ["user_first_journey_type": userFirstJourneyType]
        }
    }
    
    struct CurrentQuestNumberProperty: MixpanelProperty {
        let currentQuestNumber: Int
        
        var dictionary: [String : MixpanelType] {
            ["current_quest_number": currentQuestNumber]
        }
    }
}
