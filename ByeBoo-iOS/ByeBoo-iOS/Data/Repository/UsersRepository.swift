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
        let userID: Int = userDefaultsService.load(key: .userID) ?? 1
        let result = try await network.request(
            UsersAPI.journey(userID: userID),
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
        let userID: Int = userDefaultsService.load(key: .userID) ?? 1
        let result = try await network.request(
            UsersAPI.character(userID: userID),
            decodingType: DialogueResponseDTO.self
        )
        
        return result.dialogue
    }
    
    func fetchCompleteQuestCount() async throws -> Int {
        let userID: Int = userDefaultsService.load(key: .userID) ?? 1
        let result = try await network.request(
            UsersAPI.count(userID: userID),
            decodingType: CompleteQuestCountResponseDTO.self
        )
        
        return result.count
    }
    
    func startJourney() async throws {
        let userID: Int = userDefaultsService.load(key: .userID) ?? 1
        try await network.request(UsersAPI.start(userID: userID))
    }
    
    // MARK: Persistence
    
    func getUserName() -> String? {
        userDefaultsService.load(key: .userName)
    }
    
    func getUserID() -> Int? {
        userDefaultsService.load(key: .userID)
    }
}

struct MockUserRepository: UsersInterface {
    func getUserName() -> String? {
        "하츠핑"
    }
    
    func getUserID() -> Int? {
        1
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
    
    func fetchCompleteQuestCount() async throws -> Int {
        return 1
    }
    
    func startJourney() async throws { }
}


