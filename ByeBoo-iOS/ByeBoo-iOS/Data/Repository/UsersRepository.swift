//
//  UsersRepository.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

import Foundation

struct DefaultUsersRepository: UsersInterface {
    private let network: NetworkService
    private let userDefaultsService: UserDefaultService
    
    init(
        network: NetworkService,
        userDefaultsService: UserDefaultService
    ) {
        self.network = network
        self.userDefaultsService = userDefaultsService
    }
    
    // MARK: Network
    
    func fetchJourney() async throws -> JourneyEntity {
        let result = try await network.request(
            UsersAPI.journey,
            decodingType: UserJourneyResponseDTO.self
        )
        
        return result.toEntity()
    }
    
    func sendUser(
        name: String,
        feeling: String,
        questStyle: String
    ) async throws -> UserEntity {
        let userRequestDTO: UserRequestDTO = .init(name: name, feeling: feeling, questStyle: questStyle)
        let result = try await network.request(
            UsersAPI.sendUser(requestDTO: userRequestDTO),
            decodingType: UserResponseDTO.self
        )
        let _ = userDefaultsService.save(result.id, key: .userID)
        let _ = userDefaultsService.save(result.name, key: .userName)
        return result.toEntity()
    }
    
    func fetchCharacterDialogue() async throws -> String {
        let result = try await network.request(
            UsersAPI.character,
            decodingType: DialogueResponseDTO.self
        )
        
        return result.dialogue
    }
    
    func fetchQuestStatus() async throws -> UserQuestStatusEntity {
        let result = try await network.request(
            UsersAPI.count,
            decodingType: UserQuestStatusResponseDTO.self
        )
        
        return result.toEntity()
    }
    
    func startJourney() async throws {
        try await network.request(UsersAPI.start)
    }
    
    // MARK: Persistence
    
    func getUserName() -> String? {
        userDefaultsService.load(key: .userName)
    }
    
    func getUserID() -> Int? {
        userDefaultsService.load(key: .userID)
    }
    
    func setHelperShown() {
        _ = userDefaultsService.save(true, key: .isHelperShown)
    }
    
    func getIsHelperShown() -> Bool? {
        // TODO: 항상 helper 말풍선 뜨도록 임시 조치 -> 추후 삭제
        _ = userDefaultsService.save(false, key: .isHelperShown)
        return userDefaultsService.load(key: .isHelperShown)
    }
}

struct MockUserRepository: UsersInterface {
    func getUserName() -> String? {
        "하츠핑"
    }
    
    func getUserID() -> Int? {
        1
    }
    
    func setHelperShown() { }
    
    func getIsHelperShown() -> Bool? {
        false
    }
    
    func fetchJourney() async throws -> JourneyEntity {
        return .stub()
    }
    
    func sendUser(
        name: String,
        feeling: String,
        questStyle: String
    ) async throws -> UserEntity {
        return .stub(
            name: name,
            feeling: feeling,
            questStyle: questStyle
        )
    }
    
    func fetchCharacterDialogue() async throws -> String {
        return "천천히, 하지만 분명하게. 오늘도 나아가 봐요."
    }
    
    func fetchQuestStatus() async throws -> UserQuestStatusEntity {
        return .init(
            todayComplete: true,
            currentStatus: .afterQuest,
            questCount: 3
        )
    }
    
    func startJourney() async throws { }
}


