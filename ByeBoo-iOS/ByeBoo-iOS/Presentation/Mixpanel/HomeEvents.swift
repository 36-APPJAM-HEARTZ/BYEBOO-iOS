//
//  HomeEvents.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 9/16/25.
//

import Mixpanel

struct HomeEvents {
    enum Name {
        static let homePageView = "home_pageview"
        static let tutorialIconClick = "tutorial_icon_click"
    }
    
    struct HomePageProperty: MixpanelProperty {
        let isFirstPageView: Bool
        let journeyType: String
        
        var dictionary: [String : MixpanelType] {
            [
                "is_first_pageview": isFirstPageView,
                "journey_type": journeyType
            ]
        }
    }
}
