//
//  ProfileIcon.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/5/26.
//

import UIKit

enum ProfileIcon: String, CaseIterable {
    case sad = "SADNESS"
    case selfUnderstanding = "SELF_UNDERSTANDING"
    case soso = "SO_SO"
    case relieved = "RELIEVED"

    var image: UIImage {
        switch self {
        case .sad:
            return .sadnessBadge
        case .selfUnderstanding:
            return .selfUnderstandingBadge
        case .soso:
            return .sosoBadge
        case .relieved:
            return .relievedBadge
        }
    }

    static func image(for iconString: String) -> UIImage? {
        ProfileIcon(rawValue: iconString)?.image
    }
}
