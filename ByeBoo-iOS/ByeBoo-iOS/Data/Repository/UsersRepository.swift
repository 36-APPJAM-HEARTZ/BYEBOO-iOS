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
        userDefatulsService: UserDefaultService
    ) {
        self.network = network
        self.userDefaultsService = userDefatulsService
    }
    
    func getUserName() -> String? {
        userDefaultsService.load(key: .userName)
    }
    
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
}

struct MockUserRepository: UsersInterface {
    func getUserName() -> String? {
        "하츠핑"
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
}


