//
//  UsersInterface.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

import Foundation

protocol UsersInterface {
    func getUserName() -> String?
    func fetchJourney() async throws -> JourneyEntity
    func sendUser(name: String, feeling: String, questStyle: String) async throws -> UserEntity
    func fetchCharacterDialogue() async throws -> String
}
