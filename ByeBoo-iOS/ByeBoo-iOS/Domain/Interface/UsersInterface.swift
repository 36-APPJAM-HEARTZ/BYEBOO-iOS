//
//  UsersInterface.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

import Foundation

protocol UsersInterface {
    func getUserName() -> String?
    func modifyUserNickname(name: String) async throws -> String
    func getUserID() -> Int?
    func setHelperShown()
    func getIsHelperShown() -> Bool?
    func fetchJourney() async throws -> JourneyEntity
    func sendUser(name: String, feeling: String, questStyle: String) async throws -> UserEntity
    func fetchCharacterDialogue() async throws -> DialogueEntity
    func fetchQuestStatus() async throws -> UserQuestStatusEntity
    func startJourney() async throws
    func getIsRegistered() -> Bool
    func getLastJourneyType() -> JourneyType
    func updateNotificationPermission() async throws -> Bool
}
