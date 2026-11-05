//
//  ReviewRequestProtocol.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 11/24/25.
//

import UIKit
import StoreKit

protocol ReviewRequestProtocol {
    var requestQuestNumber: [Int] { get }
    
    @MainActor func reviewRequest()
}

extension ReviewRequestProtocol {
    var requestQuestNumber: [Int] {
        [1, 15, 30]
    }
    
    @MainActor func reviewRequest() {
        if let scene = UIApplication.shared.connectedScenes.first(
            where: { $0.activationState == .foregroundActive }
        ) as? UIWindowScene {
            AppStore.requestReview(in: scene)
        }
    }
}
