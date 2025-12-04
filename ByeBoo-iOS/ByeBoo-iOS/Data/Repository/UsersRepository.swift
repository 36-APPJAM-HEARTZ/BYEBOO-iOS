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
        let _ = userDefaultsService.save(true, key: .isOnboardingCompleted)
        let _ = userDefaultsService.save(false, key: .hasEnterMyPage)
        let _ = userDefaultsService.save(false, key: .alarmEnabled)
        
        ByeBooLogger.debug("유저 정보 저장 완료")
        return result.toEntity()
    }
    
    func fetchCharacterDialogue() async throws -> DialogueEntity {
        let result = try await network.request(
            UsersAPI.character,
            decodingType: DialogueResponseDTO.self
        )
        
        return result.toEntity()
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
        return userDefaultsService.load(key: .isHelperShown)
    }
    
    func getIsRegistered() -> Bool {
        return userDefaultsService.load(key: .isRegistered) ?? false
    }
    
    func modifyUserNickname(name: String) async throws -> String {
        let result = try await network.request(
            UsersAPI.modifyName(requestDTO: UserNameRequestDTO(name: name)),
            decodingType: UserNameResponseDTO.self
        )
        let _ = userDefaultsService.save(result.name, key: .userName)
        return result.name
    }
    
    func getLastJourneyType() -> JourneyType {
        let journey: String? = userDefaultsService.load(key: .journey)
        return JourneyType.keyToEnum(journey ?? "") ?? .face
    }
    
    func updateNotificationPermission() async throws -> Bool {
        let result = try await network.request(
            UsersAPI.updateNotificationPermission,
            decodingType: AlarmEnabledResponseDTO.self
        )
        let alarmEnabled = result.alarmEnabled
        let _ = userDefaultsService.save(alarmEnabled, key: .alarmEnabled)
        
        return alarmEnabled
    }
    
    func checkHasEnterMyPage() -> Bool {
        guard let hasEnterMyPage: Bool = userDefaultsService.load(key: .hasEnterMyPage) else {
            let _ = userDefaultsService.save(true, key: .hasEnterMyPage)
            return false
        }
        if !hasEnterMyPage {
            let _ = userDefaultsService.save(true, key: .hasEnterMyPage)
        }
        return hasEnterMyPage
    }
    
    var alarmEnabled: Bool {
        get {
            guard let alarmEnabled: Bool = userDefaultsService.load(key: .alarmEnabled) else {
                return false
            }
            return alarmEnabled
        }
    }
}

final class MockUserRepository: UsersInterface {
    var questStatus: UserQuestStatusEntity = .init(
        todayComplete: true,
        currentStatus: .afterJourney,
        questCount: 0
    )
    var isHelperShown: Bool = true
    var isAllowed = false
    
    init(
        questStatus: UserQuestStatusEntity? = nil,
        isHelperShown: Bool? = nil
    ) {
        if let questStatus {
            self.questStatus = questStatus
        }
        
        if let isHelperShown {
            self.isHelperShown = isHelperShown
        }
    }
    
    func getUserName() -> String? {
        "하츠핑"
    }
    
    func getUserID() -> Int? {
        1
    }
    
    func setHelperShown() { }
    
    func getIsHelperShown() -> Bool? {
        isHelperShown
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
    
    func fetchCharacterDialogue() async throws -> DialogueEntity {
        return .stub()
    }
    
    func fetchQuestStatus() async throws -> UserQuestStatusEntity {
        return questStatus
    }
    
    func startJourney() async throws { }
    
    func getIsRegistered() -> Bool {
        return false
    }
    
    func modifyUserNickname(name: String) -> String {
        name
    }
    
    func getLastJourneyType() -> JourneyType {
        .process
    }
    
    func updateNotificationPermission() -> Bool {
        isAllowed.toggle()
        return isAllowed
    }
    
    func checkHasEnterMyPage() -> Bool {
        return true
    }
    
    var alarmEnabled: Bool {
        return true
    }
}


