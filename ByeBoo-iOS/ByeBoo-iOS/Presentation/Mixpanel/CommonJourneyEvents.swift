//
//  CommonJourneyEvents.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 3/25/26.
//

import Mixpanel

struct CommonJourneyEvents {
    enum Name {
        static let commonJourneyPageview = "common_journey_pageview"
        static let commonJourneyWriteClick = "common_journey_write_click"
        static let commonJourneyWriteSuccess = "common_journey_write_success"
        static let CommonJourneyOthersAnswerPageview = "common_journey_others_answer_pageview"
    }
}
