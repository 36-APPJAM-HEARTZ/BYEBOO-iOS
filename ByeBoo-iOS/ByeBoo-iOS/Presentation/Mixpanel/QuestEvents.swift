//
//  QuestEvents.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 9/16/25.
//

import Mixpanel

struct QuestEvents {
    enum Name {
        static let journeyStartPageView = "journey_start_pageview"
        static let journeyStartClick = "journey_start_click"
        static let questPageView = "quest_pageview"
        static let questWritePageView = "quest_pageview"
        static let questWriteSuccess = "quest_write_success"
        static let questSuccess = "quest_success"
        static let questTipPageView = "quest_tip_pageview"
        static let questBoxClick = "quest_box_click"
        static let journeyCompletePageView = "journey_complete_pageview"
        static let journeyNewPageView = "journey_new_pageview"
        static let journeyNewClick = "journey_new_pageview"
        static let journeyReviewPageView = "journey_review_pageview"
        static let journeyReviewAllPageView = "journey_review_pageview"
    }
}

extension QuestEvents {
    struct QuestStartEnterProperty: MixpanelProperty {
        let journeyType: String
        
        var dictionary: [String : MixpanelType] {
            ["journey_type": journeyType]
        }
    }
    
    struct QuestStartProperty: MixpanelProperty {
        let journeyStartAt: String // date format 물어보기 ~
        let journeyType: String
        let isFirstJourney: Bool
        
        var dictionary: [String : MixpanelType] {
            [
                "journey_start_at": journeyStartAt,
                "journey_type": journeyType,
                "is_first_journey": isFirstJourney
            ]
        }
    }
    
    struct QuestMainProperty: MixpanelProperty {
        let journeyType: String
        let isFirstPageView: Bool
        
        var dictionary: [String : MixpanelType] {
            [
                "journey_type": journeyType,
                "is_first_pageview": isFirstPageView
            ]
        }
    }
    
    struct QuestWriteStartProperty: MixpanelProperty {
        let questStartAt: String
        let questNumber: Int
        let questType: String
        
        var dictionary: [String : any MixpanelType] {
            [
                "quest_start_at": questStartAt,
                "quest_number": questNumber,
                "quest_type": questType
            ]
        }
    }
    
    struct QuestWriteFinishProperty: MixpanelProperty {
        let questLength: Int
        let questNumber: Int
        let questType: String
        
        var dictionary: [String : any MixpanelType] {
            [
                "quest_length": questLength,
                "quest_number": questNumber,
                "quest_type": questType
            ]
        }
    }
    
    struct QuestWriteFinishWithEmotionProperty: MixpanelProperty {
        let questEndAt: String
        let questNumber: Int
        let questType: String
        let afterEmotionType: String
        
        var dictionary: [String : any MixpanelType] {
            [
                "quest_end_at": questEndAt,
                "quest_number": questNumber,
                "quest_type": questType,
                "after_emotion_type": afterEmotionType
            ]
        }
    }
    
    struct QuestTipProperty: MixpanelProperty {
        let questNumber: Int
        
        var dictionary: [String : any MixpanelType] {
            [
                "quest_number": questNumber
            ]
        }
    }
    
    struct QuestLookBackProperty: MixpanelProperty {
        let questNumber: Int
        
        var dictionary: [String : any MixpanelType] {
            [
                "quest_number": questNumber
            ]
        }
    }
    
    struct JourneyFinishProperty: MixpanelProperty {
        let journeyEndAt: String
        let journeyType: String
        
        var dictionary: [String : any MixpanelType] {
            [
                "journey_end_at": journeyEndAt,
                "journey_type": journeyType
            ]
        }
    }
    
    struct NewJourneyProperty: MixpanelProperty {
        let newJourneyType: String
        
        var dictionary: [String : any MixpanelType] {
            [
                "new_journey_type": newJourneyType
            ]
        }
    }
    
    struct QuestAllLookBackProperty: MixpanelProperty {
        let reviewJourneyType: String
        
        var dictionary: [String : any MixpanelType] {
            [
                "review_journey_type": reviewJourneyType
            ]
        }
    }
}
