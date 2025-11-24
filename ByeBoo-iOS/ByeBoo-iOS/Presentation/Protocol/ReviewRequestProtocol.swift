//
//  ReviewRequestProtocol.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 11/24/25.
//

import UIKit
import StoreKit

protocol ReviewRequestProtocol {
    func reviewRequest()
}

extension ReviewRequestProtocol {
    func reviewRequest() {
        if let scene = UIApplication.shared.connectedScenes.first(
            where: { $0.activationState == .foregroundActive }
        ) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
