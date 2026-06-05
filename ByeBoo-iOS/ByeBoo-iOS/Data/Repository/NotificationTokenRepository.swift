//
//  NotificationRepositoru.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 11/22/25.
//

struct DefaultNotificationTokenRepository: NotificationTokenInterface {
    
    private let network: NetworkService
    private let userDefaultsService: UserDefaultService
    private let keychainService: KeychainService
    
    init(
        network: NetworkService,
        userDefaultsService: UserDefaultService,
        keychainService: KeychainService
    ) {
        self.network = network
        self.userDefaultsService = userDefaultsService
        self.keychainService = keychainService
    }
    
    func loadToken() -> String? {
        guard let token: String = userDefaultsService.load(key: .fcmToken) else {
            return nil
        }
        return token
    }
    
    func sendToken(token: String) async throws {
        let accessToken = keychainService.load(key: .accessToken)
        
        guard !accessToken.isEmpty else {
            saveToken(token: token)
            return
        }
        
        let fcmTokenDTO = createDTO(token: token)
        try await network.request(
            NotificationTokenAPI.saveToken(dto: fcmTokenDTO)
        )
        saveToken(token: token)
    }
    
    func updateToken(token: String) async throws {
        let accessToken = keychainService.load(key: .accessToken)
        
        guard !accessToken.isEmpty else {
            saveToken(token: token)
            return
        }
        
        let fcmTokenDTO = createDTO(token: token)
        try await network.request(
            NotificationTokenAPI.updateToken(dto: fcmTokenDTO)
        )
        saveToken(token: token)
    }
    
    func saveToken(token: String) {
        let _ = userDefaultsService.save(token, key: .fcmToken)
    }
    
    func deleteToken(token: String) async throws {
        let fcmTokenDTO = createDTO(token: token)
        let accessToken = keychainService.load(key: .accessToken)
        try await network.request(
            NotificationTokenAPI.deleteToken(dto: fcmTokenDTO)
        )
        let _ = userDefaultsService.delete(key: .fcmToken)
    }
    
    private func createDTO(token: String) -> FCMTokenDTO {
        .init(token: token)
    }
}

final class MockNotificationTokenRepository: NotificationTokenInterface {
    
    private let userDefaultsService: UserDefaultService
    var sendTokenCalled = false
    var updateTokenCalled = false
    var deleteTokenCalled = false
    
    init(userDefaultsService: UserDefaultService) {
        self.userDefaultsService = userDefaultsService
    }
    
    func loadToken() -> String? {
        guard let token: String = userDefaultsService.load(key: .fcmToken) else {
            return nil
        }
        return token
    }
    
    func sendToken(token: String) {
        sendTokenCalled = true
        saveToken(token: token)
    }
    
    func saveToken(token: String) {
        let _ = userDefaultsService.save(token, key: .fcmToken)
    }
    
    func updateToken(token: String) {
        updateTokenCalled = true
        let _ = userDefaultsService.save(token, key: .fcmToken)
    }
    
    func deleteToken(token: String) {
        deleteTokenCalled = true
        let _ = userDefaultsService.delete(key: .fcmToken)
    }
}
