//
//  GetProgressingQuestsInterface.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/14/25.
//

import Foundation

protocol GetProgressingQuestsInterface {
    func fetchProgressingQuests(userID: Int) async throws -> ProgressingQuestsEntity
}
